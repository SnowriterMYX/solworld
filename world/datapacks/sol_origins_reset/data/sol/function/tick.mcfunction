execute as @a[scores={deaths=1..}] run function sol:reset_origin
scoreboard players set @a[scores={deaths=1..}] deaths 0
