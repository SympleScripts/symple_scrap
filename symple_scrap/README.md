# Symple Scrap

A comprehensive FiveM scrapyard material collection system that transforms vehicle wreckage props into interactive material collection points at designated scrapyard locations.

**✅ Fully compatible with ox_target and ox_inventory**

## Features

- **Two Scrapyard Locations**: Davis Scrapyard and La Mesa Scrapyard with map blips
- **Interactive Props**: 30+ different searchable vehicle wreckage and scrap props
- **Tiered Loot System**: Common, uncommon, and rare materials with realistic drop rates
- **Cooldown System**: 1-minute cooldown per prop to prevent spam
- **Zone Detection**: Players must be within scrapyard boundaries to search
- **Realistic Animations**: Search animations with progress bars


## Installation

1. Ensure you have the required dependencies installed:
   - `ox_lib`
   - `ox_inventory` 
   - `ox_target`
   - `qbx_core` (or your preferred framework)

2. Place the `symple_scrap` folder in your `[standalone]` resources directory

3. Add the following items to your `ox_inventory/data/items.lua`:

```lua
-- Common Materials
['metalscrap'] = {
    label = 'Metal Scrap',
    weight = 100,
    stack = true,
    close = true,
},
['steel'] = {
    label = 'Steel',
    weight = 150,
    stack = true,
    close = true,
},
['iron'] = {
    label = 'Iron',
    weight = 130,
    stack = true,
    close = true,
},
['copper'] = {
    label = 'Copper',
    weight = 120,
    stack = true,
    close = true,
},
['plastic'] = {
    label = 'Plastic',
    weight = 50,
    stack = true,
    close = true,
},
['rubber'] = {
    label = 'Rubber',
    weight = 80,
    stack = true,
    close = true,
},
['glass'] = {
    label = 'Glass Shards',
    weight = 60,
    stack = true,
    close = true,
},

-- Uncommon Materials
['aluminum'] = {
    label = 'Aluminum',
    weight = 100,
    stack = true,
    close = true,
},




4. Add to your `server.cfg`:
```
ensure symple_scrap
```

5. Restart your server

## Usage

1. **Visit Scrapyards**: Travel to either Davis Scrapyard or La Mesa Scrapyard (marked on map)
2. **Find Props**: Look for vehicle wreckage, car parts, and scrap props
3. **Search**: Use the interaction key (default E) when near searchable props
4. **Wait**: Complete the 4-second search animation
5. **Collect**: Receive materials directly to your inventory
6. **Cooldown**: Wait 1 minute before searching the same prop again

## Loot Tables

### Common Materials (60-70% chance)
- Metal Scrap, Steel, Iron, Copper, Plastic, Rubber, Glass

### Uncommon Materials (20-30% chance)  
- Aluminum



## Configuration

Edit `config.lua` to customize:
- Scrapyard locations and zones
- Loot tables and drop rates
- Search duration and cooldowns
- Searchable prop models
- Translation strings

## Searchable Props

The system recognizes 30+ different prop models including:
- Car bonnets and doors
- Engine blocks and chassis
- Vehicle wreckage pieces
- Truck wreckage
- Scrap metal pieces
- Wheels and tires

## Performance

- Optimized distance checking
- Efficient prop detection
- Automatic cooldown cleanup
- Zone-based interaction limiting

## Support

For issues or customization requests, contact the development team. https://discord.gg/rX7bWcNm
