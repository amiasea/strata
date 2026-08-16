terraform {
  cloud {
    organization = "amiasea"

    workspaces {
      project = "strata"
    }
  }
}