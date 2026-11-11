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
  ## also filtering out eevee because honestly as much as I want this so serve as some sort of challenge, I also have no interest in using a pokemon that I'm not allowed to give an evolution stone to because that's just not very fun and after all it is still a game, even if it's a game for children and I'm not a child
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
        "Zapdos",
        "Kingdra",
        "Sandshrew",
        "Sandslash",
        "Golem",
        "Porygon",
        "Eevee"
      )
  ) |>
  mutate(type2 = case_when(type2 %in% c("dark", "fairy") ~ NA, TRUE ~ type2))

### filtering out bug types and duplicating them in the non starters df, so they're more likely to be sampled, for an extra challenge
FRBugs <- NonStarters_FR |>
  filter(type1 == "bug" | type2 == "bug")

FRBugs_NoParasScyther <- FRBugs |>
  filter(name %nin% c("Scyther", "Paras", "Parasect"))

### splitting NonStarters_FR into 2 chunks so I can insert extra bug rows into the set of firered pokemon to make them more likely to be sampled
set.seed(pokeseed)
split_point <- sample(1:nrow(NonStarters_FR), 1)
# split_point_2 <- split_point + 1

NonStarters_FR_pt1 <- NonStarters_FR[1:split_point, ]
NonStarters_FR_pt2 <- NonStarters_FR[(split_point + 1):nrow(NonStarters_FR), ]


NonStarters_FR <- rbind(
  FRBugs,
  rbind(
    NonStarters_FR_pt1,
    rbind(FRBugs_NoParasScyther, rbind(NonStarters_FR_pt2, FRBugs))
  )
)

AllFRPokemon <- rbind(NonStarters_FR, StarterPokemon)

### seed is the current year, month, and day smashed together to be one number
## that way it's guaranteed to be different whenever I decide to play/replay a pokemon game
set.seed(pokeseed)
RandomStarter <- sample(StarterPokemonNames, 1)
# set.seed(pokeseed)
Random5 <- sample(NonStarters_FR$name, 5, replace = FALSE)
### resampling if there are duplicates
## this won't catch everything, for example if an evolution of a pokemon is included along with the original form, that wouldn't be caught here, but I don't know how to catch that without writing a big whole thing myself and I don't feel like doing that
## but it will catch most stuff, so that's nice
if (length(unique(Random5)) < 5) {
  Random5 <- sample(NonStarters_FR$name, 5, replace = FALSE)
}
### sampling a full 6 if I decide to do a challenge with no starter
### seed is the current year, month, and day smashed together to be one number
## that way it's guaranteed to be different whenever I decide to play/replay a pokemon game
# set.seed(pokeseed)
Random6 <- sample(NonStarters_FR$name, 6, replace = FALSE)
if (length(unique(Random6)) < 6) {
  Random6 <- sample(NonStarters_FR$name, 6, replace = FALSE)
}
### sampling a Full 6 with starters possible but not guaranteed
# set.seed(pokeseed)
Random6_StarterPossible <- sample(AllFRPokemon$name, 6, replace = FALSE)
if (
  length(unique(Random6_StarterPossible)) < 6 |
    sum(StarterPokemon$name %in% Random6_StarterPossible) > 1
) {
  Random6_StarterPossible <- sample(AllFRPokemon$name, 6, replace = FALSE)
}
# Random5 <- sample(NonStarters_FR$name, 5, replace = FALSE)
# Random5 <- sample(NonStarters_FR$name, 5, replace = FALSE)
### printing out sampled pokemon
RandomStarter
Random5
### selecting a random6 and a random6 with starters eligible just produce the same order if I keep the seed setting. might remove it?
Random6
Random6_StarterPossible

### if duplicates are present, I just rerun the relevant sample without resetting the seed
