local function destroy()
  local items = {
    '新鲜的石鳞鳕鱼',
    '新鲜的银头鲑鱼',
    '新鲜的光滑大鱼',
    '新鲜的红腮鱼',
    '新鲜的阳鳞鲑鱼',
    '新鲜的斑点黄尾鱼',
    '新鲜的夏日鲈鱼',
    '美味的蚌肉',
    '电鳗',

    '40磅重的石斑鱼',
    '47磅重的石斑鱼',
    '53磅重的石斑鱼',
    '59磅重的石斑鱼',
    '68磅重的石斑鱼',

    '34磅重的红腮鱼',
    '37磅重的红腮鱼',
    '42磅重的红腮鱼',
    '45磅重的红腮鱼',
    '49磅重的红腮鱼',
    '52磅重的红腮鱼',

    '黑口鱼',
    '石鳞鳗',

    '沉重的箱子',
    '锁住的铁箍箱',
  };

  for i = 0, 4, 1 do
    for j = 1, 18, 1 do
      local id = select(10, GetContainerItemInfo(i, j));

      if (id ~= nil) then
        local name = GetItemInfo(id);

        for k, v in pairs(items) do
          if name == v then
            print(v);
            PickupContainerItem(i, j);
            DeleteCursorItem();
            break;
          end
        end
      end
    end
  end
end

SLASH_WCS_DESTROY1 = '/wcs_destroy'
SlashCmdList['WCS_DESTROY'] = destroy
