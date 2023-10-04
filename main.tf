terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  /*backend "remote" {
      hostname = "app.terraform.io"
      organization = "ExamPro"

      workspaces {
        name = terra-house-1
      }
  }*/
  cloud {
    organization = "david_richey"
    workspaces {
      name = "terra-house-1"
    }
  }
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "home_games_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.games.public_path
  content_version = var.games.content_version
}

resource "terratowns_home" "home_games" {
  name = "My favorite video games"
  description = <<DESCRIPTION
Warcraft 3 and Gears of War 3 
DESCRIPTION
  domain_name = module.home_games_hosting.domain_name
  town = "gamers-grotto"
  content_version = var.games.content_version
}

module "home_artists_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.artists.public_path
  content_version = var.artists.content_version
}

resource "terratowns_home" "home_artists" {
  name = "My favorite artists"
  description = <<DESCRIPTION
Carly Rae Jepsen and Charli XCX
DESCRIPTION
  domain_name = module.home_artists_hosting.domain_name
  town = "melomaniac-mansion"
  content_version = var.artists.content_version
}