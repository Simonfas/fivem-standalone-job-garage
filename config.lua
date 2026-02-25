Config = {}

Config.OpenKey = 38 

Config.Marker = {
  enabled = true,
  type = 36,
  scale = vec3(0.6, 0.6, 0.6),
  drawDist = 25.0
}

Config.TextUI = {
    enabled = true,
    dist = 3.0
}

Config.Blips = {
  enabled = true,
  sprite = 357, 
  scale  = 0.85,
  colour = 0, 
  name   = "Garage"
}

Config.Garages = {
  {
    id = "paleto",
    label = "Paleto Bay Garage",
    coords = vec3(-446.8483, 6025.4287, 32.4901),
    interactDist = 2.0,
    spawn = { coords = vec3(-438.3190, 6028.6943, 31.3405), heading = 33.3043 },
    blip = true
  },
  {
    id = "showroom",
    label = "Showroom",
    coords = vec3(-593.6270, -932.6556, 17.5926),
    interactDist = 2.0,
    spawn = { coords = vec3(-593.6270, -932.6556, 17.5926), heading = 145 },
    blip = false
  },
  {
    id = "mountchilliad",
    label = "Mount Chilliad Garage",
    coords = vec3(481.9816, 5407.0225, 672.7202),
    interactDist = 2.0,
    spawn = { coords = vec3(476.4849, 5419.5684, 671.5647), heading = 284.4095 },
    blip = true
  },
  {
    id = "sandypd",
    label = "Sandy PD Garage",
    coords = vec3(1857.6355, 3683.1721, 35.2675),
    interactDist = 2.0,
    spawn = { coords = vec3(1853.5477, 3675.8408, 33.7616), heading = 216.7587 },
    blip = true
  },
  {
    id = "beaverbush",
    label = "Beaver bush Garage",
    coords = vec3(377.8018, 789.4936, 188.6432),
    interactDist = 2.0,
    spawn = { coords = vec3(373.4582, 788.1051, 186.9320), heading = 163.2122 },
    blip = true
  },
  {
    id = "vinewoodpd",
    label = "VineWood Garage",
    coords = vec3(-1207.5378, 327.2047, 72.1070),
    interactDist = 2.0,
    spawn = { coords = vec3(-1206.8024, 332.3681, 70.9924), heading = 280.4863 },
    blip = true
  },
  {
    id = "altastreetpd",
    label = "Alta Street Garage",
    coords = vec3(97.1365, -350.7536, 39.8378),
    interactDist = 2.0,
    spawn = { coords = vec3(100.0271, -362.7694, 38.8378), heading = 338.3619 },
    blip = true
  },
  {
    id = "mrpd",
    label = "Mission Row PD Garage",
    coords = vec3(424.2695, -1015.2133, 30.0266),
    interactDist = 2.0,
    spawn = { coords = vec3(433.9835, -1014.3307, 28.7627), heading = 181.8078 },
    blip = true
  },
  {
    id = "davispd",
    label = "Davis PD Garage",
    coords = vec3(351.5107, -1612.9989, 24.7860),
    interactDist = 2.0,
    spawn = { coords = vec3(353.0942, -1629.9440, 23.7860), heading = 139.9086 },
    blip = true
  },
  {
    id = "portstation",
    label = "Havnestation Garage",
    coords = vec3(-696.9077, -1400.4443, 6.1505),
    interactDist = 2.0,
    spawn = { coords = vec3(-681.7754, -1428.2343, 5.0008), heading = 94.3901 },
    blip = true
  },
  {
    id = "fbi",
    label = "Nødgarage",
    coords = vec3(2516.8740, -384.9644, 94.1403),
    interactDist = 2.0,
    spawn = { coords = vec3(2527.8845, -394.5617, 92.9928), heading = 216.6724 },
    blip = true
  }
}

Config.VehicleDeleters = {
  {
    id = "paleto",
    label = "Slet Din Bil",
    coords = vec3(-441.9396, 6026.8828, 32.0245),
    interactDist = 2.0
  },
  {
    id = "showroom",
    label = "Slet Din Bil",
    coords = vec3(-593.2289, -915.1646, 17.3601),
    interactDist = 2.0
  },
  {
    id = "mountchilliad",
    label = "Slet Din Bil",
    coords = vec3(473.5994, 5412.5083, 672.5607),
    interactDist = 2.0
  },
  {
    id = "sandypd",
    label = "Slet Din Bil",
    coords = vec3(1850.3683, 3673.7920, 34.7600),
    interactDist = 2.0
  },
  {
    id = "beaverbush",
    label = "Slet Din Bil",
    coords = vec3(377.2354, 778.5021, 186.0889),
    interactDist = 2.0
  },
  {
    id = "vinewoodpd",
    label = "Slet Din Bil",
    coords = vec3(-1205.6035, 340.9794, 72.0297),
    interactDist = 2.0
  },
  {
    id = "altastreetpd",
    label = "Slet Din Bil",
    coords = vec3(93.6681, -349.5826, 39.8378),
    interactDist = 2.0
  },
  {
    id = "mrpd",
    label = "Slet Din Bil",
    coords = vec3(418.1491, -1028.9321, 30.1479),
    interactDist = 2.0
  },
  {
    id = "davispd",
    label = "Slet Din Bil",
    coords = vec3(346.2004, -1622.1250, 24.7860),
    interactDist = 2.0
  },
  {
    id = "portstation",
    label = "Slet Din Bil",
    coords = vec3(-694.9263, -1405.8680, 6.0008),
    interactDist = 2.0
  },
  {
    id = "fbi",
    label = "Slet Din Bil",
    coords = vec3(2521.1443, -374.8273, 93.9928),
    interactDist = 2.0
  }
}

Config.Vehicles = {
  { label = "Jugular Markeret", model= "police2", image = "jugular.png" },
  { label = "Raiden Markeret", model= "police3", image = "raiden.png" },
  { label = "Argento Markeret", model= "sheriff", image = "argento.png" },
  { label = "I-Wagen Markeret", model= "sheriff2", image = "wagen.png" },
  { label = "BF400 Markeret", model= "policeb", image = "bf400.png" },
  { label = "Polaris Hundepatrulje", model= "fbi", image = "hund.png" },
  { label = "Schafter Umarkeret", model= "police4", image = "schafter.png" },
  { label = "Tailgater Umarkeret", model= "police", image = "tailgater.png" },
  { label = "XLS Umarkeret", model= "fbi2", image = "xls.png" },
  { label = "Indsatsleder Bil", model= "polimperial", image = "isl.png" },
  { label = "Romeo", model= "polcimperial", image = "romeo.png" },
}
