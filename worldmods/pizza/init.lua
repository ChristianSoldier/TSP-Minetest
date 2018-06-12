-- Pizza MOD
-- by vitaminx

NAME="Pizza MOD"
VERSION="0.3"

print(NAME.." "..VERSION)

-- items
minetest.register_craftitem("pizza:pizza_dough", {
    description = "Pizza Dough",
    inventory_image = "pizza_dough.png",
})

minetest.register_craftitem("pizza:pizza", {
    description = "Pizza",
    inventory_image = "pizza.png",
    on_use = minetest.item_eat(30)
})

minetest.register_craftitem("pizza:pizzaslice", {
    description = "Pizza Slice",
    inventory_image = "pizzaslice.png",
    on_use = minetest.item_eat(5)
})

minetest.register_node("pizza:pizzabox", {
    description = "Pizzabox",
    tiles = {
        "pizzabox_top.png",
        "pizzabox_bottom.png",
        "pizzabox_side.png",
        "pizzabox_side.png",
        "pizzabox_side.png",
        "pizzabox_side.png",
    },
    inventory_image = "pizzabox_top.png",
    groups = { dig_immediate=2 },
    paramtype = "light",
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, -0.5, 0.5, -0.3, 0.5 }
        }
    }
})

-- recipes
minetest.register_craft({
    output = "pizza:pizza_dough",
    recipe = {
        {"farming:flour", "food:cheese", "food:tomato"}
    }
})

minetest.register_craft({
    output = "pizza:pizza",
    type = "cooking",
    cooktime = 50.0,
    recipe = "pizza:pizza_dough"
})

minetest.register_craft({
    output = "pizza:pizzaslice 6",
    recipe = {
        {"pizza:pizza"},
    }
})

minetest.register_craft({
    output = "pizza:pizzabox",
    recipe = {
        {"", "default:paper", ""},
        {"default:paper", "pizza:pizza", "default:paper"},
        {"", "default:paper", ""}
    }
})
