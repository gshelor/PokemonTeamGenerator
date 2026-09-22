# devtools::install_github("schochastics/Rokemon")
library(pacman)
p_load(Rokemon, tidyverse)

`%nin%` <- Negate(`%in%`)

### setting seed to be used for random sampling of pokemon
pokeseed <- as.integer(paste0(
  format(Sys.Date(), "%Y"),
  format(Sys.Date(), "%m"),
  format(Sys.Date(), "%d")
))

data(pokemon)
poopypants <- as.data.frame(pokemon)

gen3 <- poopypants |>
  filter(generation <= 3)

gen1 <- poopypants |>
  filter(generation == 1)

### FireRed starters
StarterPokemonNames <- c(
  "Squirtle",
  "Charmander",
  "Bulbasaur",
  "Wartortle",
  "Charmeleon",
  "Ivysaur",
  "Blastoise",
  "Charizard",
  "Venusaur"
)

StarterPokemon <- gen1 |>
  filter(name %in% StarterPokemonNames)

### filter from gen 1 for firered because FR is almost entirely the same pokemon as in the gen 1 red game, just with updated abilities and other stuff that were introduced after gen 1
NonStarters_FR <- gen1 |>
  filter(name %nin% StarterPokemonNames) |>
  ### filtering out pokemon which are in gen 3 or previous, but not in FireRed
  filter(
    name %nin%
      c(
        "Murkrow",
        "Banette",
        "Flaaffy",
        "Pineco",
        "Misdreavus",
        "Chimecho",
        "Ampharos",
        "Gligar",
        "Wobbuffet",
        "Glalie",
        "Bellossom",
        "Granbull",
        "Bellsprout",
        "Weepinbell",
        "Victreebel",
        "Magmar",
        "Gengar",
        "Alakazam",
        "Ninetailes",
        "Vulpix",
        "Slowpoke",
        "Slowbro",
        "Pinsir",
        "Staryu",
        "Starmie",
        "Vulpix",
        "Ninetales",
        "Mew",
        "Mewtwo",
        "Articuno",
        "Moltres",
        "Zapdos"
      )
  ) |>
  mutate(type2 = case_when(type2 %in% c("dark", "fairy") ~ NA, TRUE ~ type2))

### filtering out bug types and duplicating them in the non starters df, so they're more likely to be sampled, for an extra challenge
FRBugs <- NonStarters_FR |>
  filter(type1 == "bug" | type2 == "bug")

NonStarters_FR <- rbind(FRBugs, rbind(NonStarters_FR, FRBugs))

AllFRPokemon <- rbind(NonStarters_FR, StarterPokemon)

### seed is the current year, month, and day smashed together to be one number
## that way it's guaranteed to be different whenever I decide to play/replay a pokemon game
set.seed(pokeseed)
RandomStarter <- sample(StarterPokemonNames, 1)
# set.seed(pokeseed)
Random5 <- sample(NonStarters_FR$name, 5, replace = FALSE)
### sampling a full 6 if I decide to do a challenge with no starter
### seed is the current year, month, and day smashed together to be one number
## that way it's guaranteed to be different whenever I decide to play/replay a pokemon game
# set.seed(pokeseed)
Random6 <- sample(NonStarters_FR$name, 6, replace = FALSE)
### sampling a Full 6 with starters possible but not guaranteed
# set.seed(pokeseed)
Random6_StarterPossible <- sample(AllFRPokemon$name, 6, replace = FALSE)
# Random5 <- sample(NonStarters_FR$name, 5, replace = FALSE)
# Random5 <- sample(NonStarters_FR$name, 5, replace = FALSE)
# Random5 <- sample(NonStarters_FR$name, 5, replace = FALSE)
# Random5 <- sample(NonStarters_FR$name, 5, replace = FALSE)
RandomStarter
Random5
### these two just produce the same order if I keep the seed setting. might remove it?
Random6
Random6_StarterPossible

### if duplicates are present, I just rerun the relevant sample without resetting the seed
