local ITEMS = {
  '红曜石', '黎明石', '艾露恩之星', '黄晶玉', '水玉', '夜目石', '天火钻石', '大地风暴钻石'
}

local function my_comp(a, b)
  return a.price < b.price
end

local function queryStone(curIndex)
  local stones = {}

  queryAuction(ITEMS[curIndex], function(data)
    for k, v in ipairs(data) do
      local found = false

      for kk, vv in ipairs(stones) do
        if (vv.id == v.id) then
          if (vv.price > v.price) then
            vv.price = v.price
          end

          found = true
          break
        end
      end

      if not found then
        table.insert(stones, { id = v.id, price = v.price })
      end
    end

    table.sort(stones, my_comp)
    for k, v in ipairs(stones) do
      local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType,
        itemStackCount, itemEquipLoc, itemTexture, itemSellPrice =
          GetItemInfo(v.id)

      if (string.len(itemName) <= 9 + string.len(ITEMS[curIndex])) then
        print(itemLink..': '..formatMoney(v.price))
      end
    end

    if (curIndex < #ITEMS) then
      queryStone(curIndex + 1)
    end
  end)
end



SLASH_WCS_FIND_STONE_PRICE1 = '/wcs_find_stone_price';
SlashCmdList['WCS_FIND_STONE_PRICE'] = function()
  queryStone(1)
end