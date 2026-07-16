-- symple_scrap leveling persistence
-- Run this once against your server database (or drop into your resource; oxmysql auto-detects .sql if configured).

CREATE TABLE IF NOT EXISTS `symple_scrap_levels` (
    `identifier` VARCHAR(64) NOT NULL,
    `xp` INT NOT NULL DEFAULT 0,
    `level` INT NOT NULL DEFAULT 1,
    PRIMARY KEY (`identifier`)
);
