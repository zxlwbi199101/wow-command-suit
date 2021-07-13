local ITEMS_TO_BE_MONITORED = {
  { name = '夜鳞鱼汤', buyUnder = 2000, bidUnder = 2000, alertUnder = 7526 },
  { name = '火鳞鳝鱼', buyUnder = 1000, bidUnder = 1000, alertUnder = 7999 },
};

local status = {
  monitoring = false,
  listUpdatedAt = 0,
  thread = nil,
};

local function formatMoney(price)
  return floor(price / 10000)..'|cffffd70aG|r'
    ..floor(price % 10000 / 100)..'|cffc7c7cfS|r'
    ..(price % 100)..'|cffeda55fC|r';
end

local function queryNewList(name, page)
  status.listUpdatedAt = 0;

  while not CanSendAuctionQuery() do
    coroutine.yield();
  end

  -- print('querying for '..name..' and page '..page);
  QueryAuctionItems(name, nil, nil, page);

  local queryAt = GetTime();

  while (GetTime() - queryAt < 3 and (status.listUpdatedAt == 0 or GetTime() - status.listUpdatedAt < 0.3)) do
    coroutine.yield();
  end
end

local eventFrame = CreateFrame('Frame')
eventFrame:RegisterEvent('AUCTION_ITEM_LIST_UPDATE');
eventFrame:SetScript('OnUpdate', function(_, event, ...)
  if (status.monitoring) then
    status.thread:wake();
  end
end);

eventFrame:SetScript('OnEvent', function(_, event, ...)
  if (event == 'AUCTION_ITEM_LIST_UPDATE' and status.monitoring) then
    status.listUpdatedAt = GetTime();
  end
end);

local function watchList()
  local index = 1;
  local page = 0;
  local curNum = 0;
  local totalNum = 0;

  while (status.monitoring) do
    name = ITEMS_TO_BE_MONITORED[index].name
    buyUnder = ITEMS_TO_BE_MONITORED[index].buyUnder
    bidUnder = ITEMS_TO_BE_MONITORED[index].bidUnder
    alertUnder = ITEMS_TO_BE_MONITORED[index].alertUnder

    queryNewList(name, page);
    curNum, totalNum = GetNumAuctionItems('list');
    print('there are '..curNum..' '..name..' ('..totalNum..'):')

    for i = 1, curNum do
      local name, texture, count, quanlity, canUse,
        level, levelColHeader, minBid, minIncrement, buyoutPrice,
        bidAmount, highBidder, bidderFullName, owner, ownerFullName,
        saleStatus, itemId, hasAllInfo = GetAuctionItemInfo("list", i);

      if ((buyoutPrice / count) < alertUnder) then
        PlaySoundFile("Interface\\AddOns\\WowCommandSuit\\s108.mp3");
        print(name..' '..formatMoney(buyoutPrice / count)..' is cheaper.');
      end

      if ((buyoutPrice / count) <= buyUnder) then
        print('buy '..name..' '..formatMoney(buyoutPrice / count));
      elseif ((minBid / count) <= bidUnder) then
        print('bid '..name..' '..formatMoney(minBid / count));
      end

      -- print(name..'X'..count..' '..formatMoney(minBid / count)..'('..formatMoney(buyoutPrice / count)..') '..owner)
    end

    if (page < ceil(totalNum / 50) - 1) then
      page = page + 1;
    elseif (index == #ITEMS_TO_BE_MONITORED) then
      status.thread:sleep(6);
      index = 1;
      page = 0;
    else
      index = index + 1;
      page = 0;
    end

  end
end

SLASH_WCS_AUCTION_MONITOR_START1 = '/wcs_auction_monitor_start';
SlashCmdList['WCS_AUCTION_MONITOR_START'] = function()
  if (not status.monitoring) then
    print('hello '..GetUnitName('player')..', start monitoring AH...');
    status.monitoring = true;
    status.index = 1;
    status.page = 0;
    status.thread = Thread:new(watchList);
  else
    print('hello '..GetUnitName('player')..', AH already been monitored.');
  end
end

SLASH_WCS_AUCTION_MONITOR_STOP1 = '/wcs_auction_monitor_stop'
SlashCmdList['WCS_AUCTION_MONITOR_STOP'] = function()
  status.monitoring = false;
  print('monitoring AH stopped');
end