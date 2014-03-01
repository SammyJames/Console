-------------------------------------------------
-- Console - a debug log
-- 
-- @classmod LogList
-- @author Pawkette ( pawkette.heals@gmail.com )
-- @copyright MIT
-------------------------------------------------

LogList = 
{
    first = 0,
    last = -1, 
}

function LogList:New( ... )
    local self = {}
    setmetatable( self, { __index = LogList } )

    self:Initialize()
    return self
end

function LogList:Initialize()

end

function LogList:Push( value )
    self.last = self.last + 1
    self[ self.last ] = value
end

function LogList:Pop()
    if ( self.first > self.last ) then 
        return nil
    end

    local value = self[ self.first ]
    self[ self.first ] = nil

    self.first = self.first + 1
end

function LogList:Size()
    return self.last - self.first
end

function LogList:First()
    return self.first 
end

function LogList:Last()
    return self.last
end