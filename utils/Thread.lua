Thread = {
  coro = nil,
  isSleeping = false,
  sleepTo = 0,
};

function Thread:new(func)
  local obj = {};
  setmetatable(obj, self);
  self.__index = self;

  self.coro = coroutine.create(func);
  self.isSleeping = false;
  coroutine.resume(self.coro);
  return obj;
end

function Thread:wake()
  if (coroutine.status(self.coro) == 'suspended' and (not self.isSleeping or self.sleepTo < GetTime())) then
    self.isSleeping = false;
    coroutine.resume(self.coro);
  end
end

function Thread:sleep(seconds)
  self.isSleeping = true;
  self.sleepTo = GetTime() + seconds;
  coroutine.yield()
end
