local ITEMS = {
  { name = '泪珠红曜石' },
  { name = '符文红曜石' },
  { name = '明亮红曜石' },
  { name = '精致红曜石' },
  { name = '朴素红曜石' },
  { name = '闪光红曜石' },
  { name = '圆润黎明石' },
  { name = '柔光黎明石' },
  { name = '厚重黎明石' },
  { name = '刚硬黎明石' },
  { name = '巨型黎明石' },
  { name = '闪耀黎明石' },
  { name = '迅捷黎明石' },
  { name = '致密艾露恩之星' },
  { name = '风暴艾露恩之星' },
  { name = '火花艾露恩之星' },
  { name = '邪恶黄晶玉' },
  { name = '隐秘黄晶玉' },
  { name = '高能黄晶玉' },
  { name = '辉光黄晶玉' },
  { name = '反光黄晶玉' },
  { name = '鲁莽黄晶玉' },
  { name = '坚硬水玉' },
  { name = '辐光水玉' },
  { name = '眩光水玉' },
  { name = '坚强水玉' },
  { name = '狡诈夜目石' },
  { name = '皇家夜目石' },
  { name = '炽热夜目石' },
  { name = '华丽夜目石' },
  { name = '雷鸣之天火钻石' },
  { name = '坚韧之大地风暴钻石' },
};

local function my_comp(a, b)
  return a.price > b.price
end

SLASH_WCS_FIND_LOWEST_PRICE1 = '/wcs_find_lowest_price';
SlashCmdList['WCS_FIND_LOWEST_PRICE'] = function()
  for k, v in ipairs(ITEMS) do
    v.price = 99999999
  end

  queryAuction('图鉴', function(data)
    for k, v in ipairs(data) do
      for kk, vv in ipairs(ITEMS) do
        if ('图鉴：'..vv.name == v.name and vv.price > v.price) then
          vv.price = v.price
          vv.id = v.id
        end
      end
    end

    table.sort(ITEMS, my_comp)
    for k, v in ipairs(ITEMS) do
      if (v.price < 99999999) then
        local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType,
          itemStackCount, itemEquipLoc, itemTexture, itemSellPrice =
            GetItemInfo(v.id)
        print(itemLink..': '..formatMoney(v.price))
      end
    end
  end)
end