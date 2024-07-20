--!strict

type hashMap = {}

local hash: hashMap = {}

local function hashInsert<T>(name: string, index: number, id: T): ()
	table.insert(hash,{name})
	table.insert(hash[index],id)
end

hashInsert("test", 1, 12)
hashInsert("test2", 2, 432)
hashInsert("test12", 3,564)
hashInsert("test2", 4, 1235)


print(hash)

