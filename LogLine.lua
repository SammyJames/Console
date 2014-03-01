-------------------------------------------------
-- Console - a debug log
-- 
-- @classmod LogLine
-- @author Pawkette ( pawkette.heals@gmail.com )
-- @copyright MIT
-------------------------------------------------

LogLine = 
{
    text    = '', --string
    tag     = 0, -- log category
    stamp   = '' -- timestamp
}

---
-- @local
local LogStrings = 
{
    '',
    'INF',
    'WRN',
    'ERR',
    'DBG'
}

function LogLine:New( tag, stamp, text )
    local self = {}
    setmetatable( self, { __index = LogLine } )

    self:Initialize( tag, stamp, text )
    return self 
end

function LogLine:Initialize( tag, stamp, text )
    self.tag    = tag
    self.text   = text
    self.stamp  = stamp
end

function LogLine:GetTag()
    return self.tag
end

function LogLine:GetText()

    return self.text
end

function LogLine:GetTimestamp()
    return self.stamp
end

function LogLine:GetFormatted()
    local result = '[' .. self:GetTimestamp() .. '][' .. LogStrings[ self:GetTag() ] .. ']: ' .. self:GetText()
    return result
end