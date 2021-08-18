function formatMoney(price)
  return floor(price / 10000)..'|cffffd70aG|r'
    ..floor(price % 10000 / 100)..'|cffc7c7cfS|r'
    ..(price % 100)..'|cffeda55fC|r';
end
