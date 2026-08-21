# devtools::install_github("schochastics/Rokemon")
library(pacman)
p_load(Rokemon, tidyverse)

`%nin%` <- Negate(`%in%`)

data(pokemon)
poopypants <- as.data.frame(pokemon)

gen3 <- poopypants |>
  filter(generation <= 3)

gen1 <- poopypants |>
  filter(generation == 1)

### FireRed starters
StarterPokemon <- c(
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

### change this seed upon beginning a new run
## seed is the current year, month, and day smashed together to be one number
## that way it's guaranteed to be different whenever I decide to play/replay a pokemon game
set.seed(as.integer(paste0(
  format(Sys.Date(), "%Y"),
  format(Sys.Date(), "%m"),
  format(Sys.Date(), "%d")
)))
RandomStarter <- sample(StarterPokemon, 1)

### filter from gen 1 for firered because FR is almost entirely the same pokemon as in the gen 1 red game, just with updated abilities and other stuff that were introduced after gen 1
NonStarters_FR <- gen1 |>
  filter(name %nin% StarterPokemon) |>
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
        "Starmie"
      )
  ) |>
  mutate(type2 = case_when(type2 %in% c("dark", "fairy") ~ NA, TRUE ~ type2))

### change this seed upon beginning a new run
## seed is the current year, month, and day smashed together to be one number
## that way it's guaranteed to be different whenever I decide to play/replay a pokemon game
set.seed(as.integer(paste0(
  format(Sys.Date(), "%Y"),
  format(Sys.Date(), "%m"),
  format(Sys.Date(), "%d")
)))
Random5 <- sample(NonStarters_FR$name, 5, replace = FALSE)
# Random5 <- sample(NonStarters_FR$name, 5, replace = FALSE)
# Random5 <- sample(NonStarters_FR$name, 5, replace = FALSE)
# Random5 <- sample(NonStarters_FR$name, 5, replace = FALSE)
# Random5 <- sample(NonStarters_FR$name, 5, replace = FALSE)
RandomStarter
Random5
