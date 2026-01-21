Config = {}

-- Currency symbol displayed in the UI
Config.Currency = "$"

-- Define different shop types and their specific inventories
Config.ShopTypes = {
    ['convenience'] = {
        label = "24/7 Supermarket",
        -- This shop sells everything essential + tech + tools
        categories = {'food', 'drink', 'fruit', 'tech', 'tools'}, 
        blip = { sprite = 52, color = 2, scale = 0.8 }
    },
    
    ['tech'] = {
        label = "Digital Den",
        categories = {'tech'},
        blip = { sprite = 521, color = 1, scale = 0.8 }
    },
    
    ['hardware'] = {
        label = "You Tool",
        categories = {'tools'},
        blip = { sprite = 402, color = 5, scale = 0.8 }
    }
}

Config.ShopLocations = {
    { pos = vector3(25.75, -1347.0, 29.5),   type = 'convenience' },
    { pos = vector3(-707.67, -914.22, 19.21), type = 'convenience' }, 
    { pos = vector3(1135.8, -982.28, 46.41),  type = 'convenience' },       
    { pos = vector3(2748.0, 3473.0, 55.67),   type = 'convenience' },   
    { pos = vector3(1960.8, 3741.2, 32.34),   type = 'convenience' },  
    { pos = vector3(2556.8, 382.1, 108.62),   type = 'convenience' },  
}

Config.Items = {
    { label = "iPhone 13",     name = "phone",     price = 1000, image = "phone.png",     category = "tech" },
    { label = "Repair Kit",    name = "fixkit",    price = 500,  image = "repairkit.png", category = "tools" },
    { label = "Bread",         name = "bread",     price = 2,    image = "bread.png",     category = "food" },
    { label = "Water",         name = "water",     price = 1,    image = "water.png",     category = "drink" },
}