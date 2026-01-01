// Lista de Veículos por Categoria (Atualizada via FiveM Docs)
const vehicleCategories = {
    "Compacts": [
        "asbo", "blista", "brioso", "brioso2", "brioso3", "club", "dilettante", "dilettante2", 
        "issi2", "issi3", "issi4", "issi5", "issi6", "kanjo", "panto", "prairie", "rhapsody", "weevil"
    ],
    "Sedans": [
        "asea", "asea2", "asterope", "asterope2", "cinquemila", "driftchavosv6", "cog55", "cog552", 
        "cognoscenti", "cognoscenti2", "deity", "hardy", "drifthardy", "emperor", "emperor2", "emperor3", 
        "fugitive", "glendale", "glendale2", "impaler5", "ingot", "intruder", "minimus", "limo2", 
        "premier", "primo", "primo2", "regina", "rhinehart", "romero", "schafter2", "schafter5", 
        "schafter6", "stafford", "stanier", "stratum", "stretch", "superd", "surge", "tailgater", 
        "tailgater2", "warrener", "warrener2", "washington"
    ],
    "SUVs": [
        "aleutian", "astron", "baller", "baller2", "baller3", "baller4", "baller5", "baller6", 
        "baller7", "baller8", "bjxl", "cavalcade", "cavalcade2", "cavalcade3", "contender", "dorado", 
        "dubsta", "dubsta2", "everon3", "fq2", "granger", "granger2", "gresley", "habanero", 
        "huntley", "issi8", "iwagen", "jubilee", "landstalker", "landstalker2", "mesa", "mesa2", 
        "novak", "patriot", "patriot2", "radi", "rebla", "rocoto", "seminole", "seminole2", 
        "serrano", "squaddie", "toros", "vivanite", "woodlander", "xls", "xls2"
    ],
    "Coupes": [
        "cogcabrio", "driftfr36", "exemplar", "f620", "felon", "felon2", "fr36", "jackal", 
        "kanjosj", "oracle", "oracle2", "postlude", "previon", "sentinel", "sentinel2", 
        "windsor", "windsor2", "zion", "zion2"
    ],
    "Muscle": [
        "blade", "brigham", "broadway", "buccaneer", "buccaneer2", "chino", "chino2", "clique", 
        "clique2", "coquette3", "deviant", "dominator", "dominator2", "dominator3", "dominator4", 
        "dominator5", "dominator6", "dominator7", "dominator8", "dominator9", "driftdominator10", 
        "driftyosemite", "dukes", "dukes2", "dukes3", "ellie", "eudora", "faction", "faction2", 
        "faction3", "gauntlet", "gauntlet2", "gauntlet3", "gauntlet4", "gauntlet5", "driftgauntlet4", 
        "greenwood", "hermes", "hotknife", "hustler", "impaler", "impaler2", "impaler3", "impaler4", 
        "imperator", "imperator2", "imperator3", "lurcher", "moonbeam", "moonbeam2", "nightshade", 
        "phoenix", "picador", "ratloader", "ratloader2", "ruiner", "ruiner2", "ruiner3", "sabregt", 
        "sabregt2", "slamvan", "slamvan2", "slamvan3", "slamvan4", "slamvan5", "slamvan6", "stallion", 
        "tampa", "tulip", "tulip2", "drifttulip2", "vabrega", "vigero", "vigero2", "virgo", "virgo2", 
        "virgo3", "voodoo", "voodoo2", "yosemite", "yosemite2"
    ],
    "Sports Classics": [
        "arident", "bestia", "btype", "btype2", "btype3", "casco", "cheetah2", "cheetah3", 
        "coquette2", "deluxo", "dynasty", "fagaloa", "gt500", "infernus2", "jb700", "jb7002", 
        "mamba", "manana", "michelli", "monroe", "nebula", "peyote", "peyote3", "pigalle", 
        "rapidgt3", "retinue", "retinue2", "savestra", "stinger", "stingergt", "stromberg", 
        "swinger", "toreador", "torero", "tornado", "tornado2", "tornado3", "tornado4", 
        "tornado5", "tornado6", "turismo2", "viseris", "z190", "zion3", "ztype"
    ],
    "Sports": [
        "alpha", "banshee", "bestiagts", "blista2", "blista3", "buffalo", "buffalo2", "buffalo3", 
        "calico", "carbonizzare", "comet2", "comet3", "comet4", "comet5", "comet6", "comet7", 
        "coquette", "coquette4", "corsita", "coureur", "cypher", "driftsultan2", "elegy", 
        "elegy2", "eurus", "feltzer", "flashgt", "furoregt", "fusilade", "futo", "futo2", 
        "growler", "gt12", "gto", "gto2", "helios", "imorgon", "issis7", "italigto", "italirsx", 
        "jester", "jester2", "jester3", "jester4", "jugular", "khamelion", "kuruma", "kuruma2", 
        "loco", "lynx", "massacro", "massacro2", "neo", "ninef", "ninef2", "omnis", "omnisegt", 
        "pariah", "penumbra", "penumbra2", "raiden", "rapidgt", "rapidgt2", "rarara", "revolter", 
        "ruston", "schlagen", "seven70", "specter", "specter2", "stratum", "sultan", "surano", 
        "sz", "vanguard", "verlierer", "virtue", "vittone"
    ],
    "Super": [
        "adder", "autarch", "banshee2", "bullet", "cheetah", "cyclone", "cyclone2", "deveste", 
        "emerus", "entityxf", "entityxxr", "entity3", "fmj", "furia", "gp1", "ignus", "ignus2", 
        "infernus", "italigtb", "italigtb2", "krieger", "le7b", "nero", "nero2", "osiris", 
        "penetrator", "pfister811", "pipistrello", "proto", "reaper", "sc1", "sultanrs", "t20", 
        "taipan", "tempesta", "tezeract", "thrax", "tigon", "turismors", "tyrant", "vacca", 
        "vagner", "visione", "voltic", "voltic2", "xa21", "zentorno", "zorrusso"
    ],
    "Motorcycles": [
        "akuma", "avarus", "bagger", "bati", "bati2", "bf400", "carbonrs", "chimera", "cliffhanger", 
        "daemon", "daemon2", "deathbike", "deathbike2", "deathbike3", "defiler", "diabolus", 
        "diabolus2", "double", "enduro", "esskey", "faggio", "faggio2", "faggio3", "fcr", "fcr2", 
        "gargoyle", "hakuchou", "hakuchou2", "hexer", "innovation", "lectro", "manchez", "manchez2", 
        "nemesis", "nightblade", "oppressor", "oppressor2", "pcj", "powersurge", "ratbike", 
        "reever", "ruffian", "sanchez", "sanchez2", "sanctus", "shinobi", "sovereign", "stryder", 
        "thrust", "vader", "vindicator", "vortex", "wolfsbane", "zombiea", "zombieb"
    ],
    "Off-Road": [
        "advanthardy", "bifta", "blazer", "blazer2", "blazer3", "blazer4", "blazer5", "bodhi", 
        "brawler", "bruiser", "bruiser2", "bruiser3", "caracara", "caracara2", "cliffhanger", 
        "desertraid", "draugur", "dubsta3", "dune", "dune2", "dune3", "dune4", "dune5", "insurgent", 
        "insurgent2", "insurgent3", "injection", "kalahari", "kamacho", "lguard", "marshall", 
        "mesa3", "monster", "outfree", "rancherxl", "rebel", "rebel2", "riata", "sandking", 
        "sandking2", "technical", "technical2", "technical3", "trophytruck", "trophytruck2", "verus", "wastelander"
    ],
    "Vans": [
        "bison", "bison2", "bison3", "bobcatxl", "boxville", "boxville2", "boxville3", "boxville4", 
        "boxville5", "burrito", "burrito2", "burrito3", "burrito4", "burrito5", "camper", 
        "gburrito", "gburrito2", "journey", "journey2", "minivan", "minivan2", "moonbeam", 
        "moonbeam2", "paradise", "pony", "pony2", "rumpo", "rumpo2", "rumpo3", "speedo", 
        "speedo2", "speedo4", "surfer", "surfer2", "taco", "youga", "youga2", "youga3"
    ],
    "Cycles": [
        "bmx", "cruiser", "fixter", "scorcher", "tribike", "tribike2", "tribike3"
    ],
    "Boats": [
        "dinghy", "dinghy2", "dinghy3", "dinghy4", "jetmax", "marquis", "seashark", "seashark2", 
        "seashark3", "speeder", "speeder2", "squalo", "squalo2", "submersible", "submersible2", 
        "toro", "toro2", "tropic", "tropic2", "tug"
    ],
    "Helicopters": [
        "akula", "annihilator", "annihilator2", "buzzard", "buzzard2", "cargobob", "cargobob2", 
        "cargobob3", "cargobob4", "conada", "conada2", "frogger", "frogger2", "havok", "hunter", 
        "maverick", "polmav", "savage", "seasparrow", "seasparrow2", "seasparrow3", "skylift", 
        "supervolito", "supervolito2", "swift", "swift2", "valkyrie", "valkyrie2", "volatus"
    ],
    "Planes": [
        "alkonost", "alphaz1", "avenger", "avenger2", "besra", "blimp", "blimp2", "blimp3", 
        "bombushka", "cuban800", "dodo", "duster", "howard", "hydra", "jet", "luxor", "luxor2", 
        "mammatus", "microlight", "miljet", "mogul", "molotok", "nimbus", "nokota", "pyro", 
        "rogue", "seabreeze", "shamal", "starlight", "starling", "stunt", "titan", "tula", 
        "velum", "velum2", "vestra", "volatol", "v65"
    ],
    "Service": [
        "airtug", "bus", "coach", "pbus", "pbus2", "police", "police2", "police3", "police4", 
        "policeb", "policet", "rentalbus", "ripley", "scrap", "taxi", "tourbus", "trash", "trash2"
    ],
    "Emergency": [
        "ambulance", "fbi", "fbi2", "firetruk", "lguard", "pbus2", "police", "police2", 
        "police3", "police4", "policeb", "policet", "pranger", "riot", "riot2", "sheriff", "sheriff2"
    ],
    "Military": [
        "apc", "barracks", "barracks2", "barracks3", "chernobog", "crusader", "halftrack", 
        "khanjali", "rhino", "scarab", "scarab2", "scarab3", "thruster", "trailersmall2"
    ],
    "Open Wheel": [
        "br8", "dr1", "pr4", "r88"
    ],
    "Commercial": [
        "armytanker", "benson", "biff", "hauler", "hauler2", "mule", "mule2", "mule3", 
        "mule4", "packer", "phantom", "phantom2", "phantom3", "pounder", "pounder2", "stockade", "stockade2"
    ],
    "Utility": [
        "caddy", "caddy2", "caddy3", "docktug", "forklift", "mower", "sadler", "sadler2", 
        "towtruck", "towtruck2", "tractor", "tractor2", "tractor3", "utilitybook", "utilitytruck", "utilitytruck3"
    ]
};

const vehicleColors = {
    "Metallic": [
        { name: "Black", id: 0 }, { name: "Graphite Black", id: 1 }, { name: "Black Steel", id: 2 },
        { name: "Dark Silver", id: 3 }, { name: "Silver", id: 4 }, { name: "Blue Silver", id: 5 },
        { name: "Steel Gray", id: 6 }, { name: "Shadow Silver", id: 7 }, { name: "Stone Silver", id: 8 },
        { name: "Midnight Silver", id: 9 }, { name: "Gun Metal", id: 10 }, { name: "Anthracite Black", id: 11 },
        { name: "Red", id: 27 }, { name: "Torino Red", id: 28 }, { name: "Formula Red", id: 29 },
        { name: "Blaze Red", id: 30 }, { name: "Graceful Red", id: 31 }, { name: "Garnet Red", id: 32 },
        { name: "Desert Red", id: 33 }, { name: "Cabernet Red", id: 34 }, { name: "Candy Red", id: 35 },
        { name: "Sunrise Orange", id: 36 }, { name: "Classic Gold", id: 37 }, { name: "Orange", id: 38 },
        { name: "Gold", id: 99 }, { name: "Champagne", id: 102 }, { name: "Bronze", id: 90 },
        { name: "Dark Blue", id: 61 }, { name: "Midnight Blue", id: 62 }, { name: "Saxon Blue", id: 63 },
        { name: "Blue", id: 64 }, { name: "Mariner Blue", id: 65 }, { name: "Harbor Blue", id: 66 },
        { name: "Diamond Blue", id: 67 }, { name: "Surf Blue", id: 68 }, { name: "Nautical Blue", id: 69 },
        { name: "Bright Blue", id: 70 }, { name: "Purple Blue", id: 71 }, { name: "Spinnaker Blue", id: 72 },
        { name: "Ultra Blue", id: 73 }, { name: "Taxi Yellow", id: 88 }, { name: "Race Yellow", id: 89 },
        { name: "Green", id: 50 }, { name: "Racing Green", id: 51 }, { name: "Sea Green", id: 52 },
        { name: "Olive Green", id: 53 }, { name: "Bright Green", id: 54 }, { name: "Gasoline Green", id: 55 },
        { name: "Lime Green", id: 92 }
    ],
    "Matte": [
        { name: "Black", id: 12 }, { name: "Gray", id: 13 }, { name: "Light Gray", id: 14 },
        { name: "Ice White", id: 131 }, { name: "Blue", id: 83 }, { name: "Dark Blue", id: 82 },
        { name: "Midnight Blue", id: 84 }, { name: "Midnight Purple", id: 149 }, { name: "Schafter Purple", id: 148 },
        { name: "Red", id: 39 }, { name: "Dark Red", id: 40 }, { name: "Orange", id: 41 },
        { name: "Yellow", id: 42 }, { name: "Lime Green", id: 55 }, { name: "Green", id: 128 },
        { name: "Forest Green", id: 151 }, { name: "Foliage Green", id: 155 }, { name: "Olive Darb", id: 152 },
        { name: "Dark Earth", id: 153 }, { name: "Desert Tan", id: 154 }
    ],
    "Metals": [
        { name: "Brushed Steel", id: 117 }, { name: "Brushed Black Steel", id: 118 }, { name: "Brushed Aluminum", id: 119 },
        { name: "Pure Gold", id: 158 }, { name: "Brushed Gold", id: 159 }, { name: "Chrome", id: 120 }
    ],
    "Unnamed Colours": [
         { name: "Util Black", id: 15 }, { name: "Util Black Poly", id: 16 }, { name: "Util Dark Silver", id: 17 },
         { name: "Util Silver", id: 18 }, { name: "Util Gun Metal", id: 19 }, { name: "Util Shadow Silver", id: 20 },
         { name: "Worn Black", id: 21 }, { name: "Worn Graphite", id: 22 }, { name: "Worn Silver Grey", id: 23 },
         { name: "Worn Silver", id: 24 }, { name: "Worn Blue Silver", id: 25 }, { name: "Worn Shadow Silver", id: 26 },
         { name: "Worn Red", id: 43 }, { name: "Worn Dark Red", id: 44 }, { name: "Worn Orange", id: 45 },
         { name: "Worn Dark Brown", id: 94 }, { name: "Worn Rust", id: 95 }, { name: "Worn Brown", id: 96 },
         { name: "Worn Earth", id: 97 }, { name: "Worn Orange", id: 98 }, { name: "Worn White", id: 121 },
         { name: "Worn Moss Green", id: 123 }, { name: "Worn Swamp Green", id: 124 }, { name: "Worn Straw Brown", id: 126 },
         { name: "Util Brown", id: 108 }, { name: "Util Medium Brown", id: 109 }, { name: "Util Light Brown", id: 110 },
         { name: "Util Off White", id: 122 }
    ]
};