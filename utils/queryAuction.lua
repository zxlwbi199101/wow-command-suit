local status = {
  keyword = '',
  callback = nil,
  querying = false,
  listUpdatedAt = 0,
  thread = nil,
};

local eventFrame = CreateFrame('Frame')
eventFrame:SetScript('OnUpdate', function(_, event, ...)
  if (status.querying) then
    status.thread:wake();
  end
end);

eventFrame:RegisterEvent('AUCTION_ITEM_LIST_UPDATE');
eventFrame:SetScript('OnEvent', function(_, event, ...)
  if (event == 'AUCTION_ITEM_LIST_UPDATE' and status.querying) then
    status.listUpdatedAt = GetTime();
  end
end);

local function doQuery(name, page)
  status.listUpdatedAt = 0;

  while not CanSendAuctionQuery() do
    coroutine.yield();
  end

  QueryAuctionItems(name, nil, nil, page);

  local queryAt = GetTime();
  while (GetTime() - queryAt < 3 and (status.listUpdatedAt == 0 or GetTime() - status.listUpdatedAt < 0.3)) do
    coroutine.yield();
  end
end


local function loop()
  while true do
    if not status.querying then
      coroutine.yield()
    end

    local page = 0
    local response = {}

    while status.querying do
      doQuery(status.keyword, page)

      curNum, totalNum = GetNumAuctionItems('list');
      print('there are '..curNum..' '..status.keyword..' ('..totalNum..'):')

      for i = 1, curNum do
        local name, texture, count, quanlity, canUse,
          level, levelColHeader, minBid, minIncrement, buyoutPrice,
          bidAmount, highBidder, bidderFullName, owner, ownerFullName,
          saleStatus, itemId, hasAllInfo = GetAuctionItemInfo("list", i);

        local price = buyoutPrice / count
        if (buyoutPrice == 0) then
          price = 9999999999
        end

        table.insert(response, {
          name = name,
          price = price,
          id = itemId,
        })
      end

      if (curNum < 50 or 50 * (page + 1) == totalNum) then
        status.querying = false
        status.callback(response)
        break
      else
        page = page + 1
      end
    end
  end
end

function queryAuction(keyword, callback)
  if (status.querying) then
    print('auction is busy right now.')
    return
  end

  status.keyword = keyword
  status.callback = callback
  status.querying = true
end

status.thread = Thread:new(loop)