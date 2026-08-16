# Amiasea API — Strata Promotion

The Amiasea API is part of the delivery machinery established by Institutive.

Its initial capability is orchestration of Strata promotion, beginning with the Speculative promotional stage.

The API is not the implementation of Strata itself. It coordinates the delivery mechanisms through which Strata work is promoted.

## Scope

The initial implementation supports:

```text
Amiasea API
└── Strata promotion
    └── Speculative
```

The API is intentionally being developed with the expectation that it will eventually support other promotional stages and work streams.

Those extensions should be introduced when their semantics are understood rather than being generalized prematurely.

## Responsibility

The API is the orchestration authority for promotion.

It maintains and evaluates delivery state that cannot appropriately be represented by Terraform, GitHub, or TFE alone.

For Strata Speculative, this includes:

* candidate state;
* speculative seat allocation;
* candidate queue;
* candidate-to-environment assignment;
* eligibility;
* refresh decisions;
* workflow dispatch; and
* reconciliation of observed execution results.

The API does not establish the underlying Strata infrastructure.

Terraform establishes the speculative Hosting capacity, including the configured number of Hosting resource groups and the Collective resource group.

## Execution Model

The API does not execute Terraform directly.

It determines what execution should occur and dispatches an appropriate GitHub Actions workflow.

```text
GitHub event
    ↓
Amiasea API
    ↓
orchestration decision
    ↓
GitHub Actions
    ↓
TFE
    ↓
Terraform
```

The workflow is an execution mechanism rather than an orchestration authority.

A workflow does not need to call the API to request a seat, update queue state, or report completion.

## Event Model

GitHub provides events describing repository and workflow activity.

Relevant events are delivered to the API through GitHub webhooks.

For Speculative, these include:

* pull request opened;
* pull request reopened;
* pull request updated;
* pull request closed;
* pull request merged;
* branch changes;
* workflow run completed; and
* other events required to reconcile delivery state.

The API evaluates these events against the current promotional state.

The event model is independent of whether the underlying execution is performed by one workflow or several workflows.

## One-Way Workflow Communication

The API may dispatch a workflow, but the workflow does not communicate directly with the API.

```text
Amiasea API
    │
    │ dispatch
    ▼
GitHub Actions
    │
    │ execution
    ▼
TFE
```

Execution results are observed through GitHub and TFE events rather than through workflow callbacks.

In particular, GitHub's `workflow_run` webhook provides the API with an event when a workflow run completes.

This creates a deliberate separation:

> The API commands execution; GitHub reports execution.

## Speculative Orchestration

Speculative provides a bounded pool of Hosting environments.

For example:

```text
amiasea-speculative
├── hosting-instance-1
├── hosting-instance-2
└── collective
```

Terraform establishes that capacity.

The API determines which candidate occupies which available Hosting environment.

For example:

```text
hosting-instance-1 → PR #101
hosting-instance-2 → PR #107
PR #112             → queued
```

The API therefore manages occupancy rather than infrastructure capacity.

Kubernetes scaling is unrelated to this mechanism.

## Candidate Queue

The queue exists in the API.

A pull request does not obtain a speculative environment merely by existing.

A candidate may be eligible for Speculative promotion while no seat is available.

In that case, the API maintains its queued state until allocation becomes possible.

```text
PR
 ↓
eligible
 ↓
queued
 ↓
seat available
 ↓
allocated
 ↓
workflow dispatched
```

The queue is therefore delivery state, not GitHub repository state and not Terraform state.

## Candidate Allocation

When a speculative seat becomes available, the API evaluates eligible queued candidates and selects the next candidate according to the applicable delivery rules.

The API then establishes the candidate-to-environment assignment before dispatching the deployment workflow.

The workflow receives the information required to execute that assignment.

The workflow does not independently select an environment.

## Candidate Cleanup

When a candidate is closed without being merged, the API recognizes the lifecycle event and determines that its speculative realization should be destroyed.

The API dispatches the cleanup workflow.

The workflow performs the candidate-level destruction.

```text
PR closed without merge
    ↓
Amiasea API
    ↓
cleanup workflow
    ↓
terraform destroy
    ↓
candidate realization removed
    ↓
seat available
```

The speculative Hosting environment remains established.

Only the candidate realization is destroyed.

## Merged Candidates

A candidate merged into development does not necessarily require immediate destruction.

The API may allow the existing realization to remain while the speculative lifecycle determines whether the seat should subsequently be released or reconciled.

This allows different speculative environments to have different candidate histories without requiring all environments to be continuously synchronized.

## Development Refresh

Speculative may require reconciliation against the development baseline after sufficient development changes have accumulated.

The API evaluates the configured refresh conditions and determines which environments are eligible for refresh.

An occupied candidate environment is not blindly overwritten.

The API may therefore distinguish:

```text
available environment
    → eligible for refresh

candidate-occupied environment
    → preserve candidate
```

When a refresh is authorized, the API dispatches the appropriate workflow.

The workflow performs the actual infrastructure operation.

## Workflow Surface

The initial Strata repository provides the execution workflows:

```text
.github/workflows/
├── speculative-pr.yml
├── speculative-deploy.yml
├── speculative-cleanup.yml
└── speculative-refresh.yml
```

These workflows are implementation mechanisms for the Strata promotion capability.

They are not themselves the definition of the Speculative ontology.

Their responsibilities should remain narrow:

* receive execution inputs;
* execute the required operation;
* expose execution results through GitHub;
* terminate with an appropriate workflow status.

Orchestration decisions remain with the API.

## Boundaries

The API does not own:

* Strata hosting infrastructure;
* resource-group creation;
* cluster definitions;
* Kubernetes scaling;
* Terraform state;
* TFE workspace state;
* application semantics; or
* the semantic definition of Speculative.

Those belong to the appropriate systems and work streams.

The API owns the **coordination of delivery activity** across those systems.

## Work Stream Relationship

The API is established as part of Institutive's delivery machinery.

Its first consumer is Strata.

```text
Institutive
    │
    └── Amiasea API
          │
          └── Strata promotion
                │
                └── Speculative
```

This does not make the API a Strata resource.

Similarly, the GitHub workflows used to promote Strata are not themselves Strata hosting work.

They are mechanisms through which Strata work is promoted.

## Future Scope

The API is expected to eventually support additional promotional stages and work streams.

Potential future scope includes:

```text
Amiasea API
├── Strata
│   ├── Speculative
│   ├── Prospective
│   └── Operative
│
└── Kitting
    ├── Speculative
    ├── Prospective
    └── Operative
```

The implementation should not assume that these stages share identical mechanics.

Each promotional stage may have its own lifecycle, topology, allocation model, reconciliation rules, and execution mechanisms.

The API should therefore provide reusable orchestration primitives where the semantics genuinely overlap while preserving stage-specific behavior where they differ.

> **The Amiasea API coordinates delivery; it does not define the work being delivered.**
