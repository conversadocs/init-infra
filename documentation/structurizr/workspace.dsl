workspace "init-infra" {
    !identifiers hierarchical
    !docs documentation
    !adrs adrs

    model {
      !include softwareSystem/terraform.dsl
    }

    views {
      branding {
          logo "assets/logo.png"
      }

      container terraform "terraform" "The Terraform Resources" {
        include *
      }

      component terraform.cicd "CICD" "CI/CD Resources" {
        include *
      }

      component terraform.prime "PRIME" "The PRIME AWS Account" {
        include *
      }

      styles {

        themes "https://static.structurizr.com/themes/amazon-web-services-2023.01.31/theme.json" "https://static.structurizr.com/themes/amazon-web-services-2020.04.30/theme.json"
      }
    }
}
