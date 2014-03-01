-------------------------------------------------
-- Console - a debug log
-- 
-- @classmod Console
-- @author Pawkette ( pawkette.heals@gmail.com )
-- @copyright MIT
-------------------------------------------------

---
-- @table LogLevels
LogLevels = 
{
    NONE = 1, -- Log Nothing
    INFO = 2, -- Log Info ( print )
    WARNING = 3, -- Log Warnings
    ERROR = 4, -- Log Errors
    DEBUG = 5 -- Log Everything
}

local DirtyFlags =
{
    NEW_LINES = 1,
    FILTER_CHANGED = 2
}

--- 
-- @local
local HumanStrings =
{
    'None', 'Info', 'Warnings', 'Errors', 'Debug'
}

--- Convert Log Level to string
-- @local
local function LevelToString( level )
    if ( level > #HumanStrings or level < 1 ) then
        return ''
    else
        return HumanStrings[ level ]
    end
end

--- Log level color codes
-- @local 
local LogLevelColors =
{
    { r = 0,    g = 0,      b = 0   },
    { r = 255,  g = 255,    b = 255 },
    { r = 255,  g = 255,    b = 0   },
    { r = 255,  g = 0,      b = 0   },
    { r = 0,    g = 255,    b = 0   }
}

_G['d']       = function( ... ) CONSOLE:LogDebug( ... )   end
_G['print']   = function( ... ) CONSOLE:LogInfo( ... )    end
_G['info']    = function( ... ) CONSOLE:LogInfo( ... )    end
_G['warn']    = function( ... ) CONSOLE:LogWarning( ... ) end
_G['error']   = function( ... ) CONSOLE:LogError( ... )   end
_G['debug']   = function( ... ) CONSOLE:LogDebug( ... )   end

--- Console is a child of ZO_Object
--
Console = ZO_Object:Subclass()
Console.log_level = LogLevels.DEBUG
Console.log_lines = LogList:New()
Console.dirty_flags = {}
Console.last_index = 1

function Console:New( ... ) 
    local result = ZO_Object.New( self )
    result:Initialize( ... )

    return result
end

--- initialize UI
-- @tparam table control the GuiXml frame
function Console:Initialize( control )
    self.control = control
    self.textBuffer = control:GetNamedChild( '_Buffer' )
    self.dropDown = ZO_ComboBox_ObjectFromContainer( control:GetNamedChild( '_ComboBox' ) )
    self.closeBtn = control:GetNamedChild( '_Close' )
    self.clearBtn = control:GetNamedChild( '_Clear' ) 
    self.dropDown:SetSelectedItemFont( 'ZoFontWinH2' )
    self.dropDown:SetDropdownFont( 'ZoFontHeader2' )
    self.dropDown:SetSpacing( 8 )

    self.dropDown:AddItem( self.dropDown:CreateItemEntry( LevelToString( LogLevels.NONE ), function( ... ) self:SetLogLevel( LogLevels.NONE ) end ) )
    self.dropDown:AddItem( self.dropDown:CreateItemEntry( LevelToString( LogLevels.INFO ), function( ... ) self:SetLogLevel( LogLevels.INFO ) end ) )
    self.dropDown:AddItem( self.dropDown:CreateItemEntry( LevelToString( LogLevels.WARNING ), function( ... ) self:SetLogLevel( LogLevels.WARNING ) end ) )
    self.dropDown:AddItem( self.dropDown:CreateItemEntry( LevelToString( LogLevels.ERROR ), function( ... ) self:SetLogLevel( LogLevels.ERROR ) end ) )
    self.dropDown:AddItem( self.dropDown:CreateItemEntry( LevelToString( LogLevels.DEBUG ), function( ... ) self:SetLogLevel( LogLevels.DEBUG ) end ) )

    self.dropDown:SetSelectedItem( LevelToString( self.log_level ) )

    self.control:SetHandler( 'OnUpdate', function() self:OnUpdate() end )
    self.closeBtn:SetHandler( 'OnClicked', function() self:Hide() end )
    self.clearBtn:SetHandler( 'OnClicked', function() self.textBuffer:Clear() end )
    self.textBuffer:SetHandler( 'OnMouseWheel', function( ... ) self:OnScroll( ... ) end )
end

function Console:IsDirty( flag )
    if ( not flag ) then return #self.dirty_flags ~= 0 end 

    for _,v in pairs( self.dirty_flags ) do
        if ( v == flag ) then
            return true
        end
    end

    return false
end

function Console:OnUpdate()
    if ( not self:IsDirty() ) then
        return
    end

    if ( self:IsDirty( DirtyFlags.FILTER_CHANGED ) ) then
        self.textBuffer:Clear()
        self.last_index = 1
        self:AddNewLines()
        self.last_index = self.log_lines:Last()
    end

    if ( self:IsDirty( DirtyFlags.NEW_LINES ) ) then
        self:AddNewLines()
        self.last_index = self.log_lines:Last()
    end

    self.dirty_flags = {}
end

function Console:AddNewLines()
    local color = {}
    local entry = {}
    for i = self.last_index, self.log_lines:Last(), 1 do
        entry = self.log_lines[ i ]
        if ( self.log_level >= entry:GetTag() ) then
            color = LogLevelColors[ entry:GetTag() ]
            self.textBuffer:AddMessage( entry:GetFormatted(), color.r, color.g, color.b, nil )
        end
    end
end

--- Show this
-- 
function Console:Show()
    self.control:SetHidden( false )
end

--- Hide this
--
function Console:Hide()
    self.control:SetHidden( true )
end

--- Scroll text buffer
-- @tparam table _ ignored self param
-- @tparam number delta mouse wheel delta
-- @tparam boolean ctrl control key state
-- @tparam boolean alt alt key state
-- @tparam boolean shift shift key state
function Console:OnScroll( _, delta, ctrl, alt, shift )
    if ( shift ) then
        delta = delta * self.textBuffer:GetNumVisibleLines()
    elseif ( ctrl ) then
        delta = delta * self.textBuffer:GetNumHistoryLines()
    end

    self.textBuffer:SetScrollPosition( self.textBuffer:GetScrollPosition() + delta )
end

--- Log something to the window
-- @tparam LogLevels logLevel
-- @tparam string fmt will convert to string if not a string
-- @param ...
function Console:Log( logLevel, fmt, ... )
    if ( type( fmt ) ~= 'string' ) then 
        fmt = tostring( fmt )
    end

    if ( self.log_level >= logLevel ) then
        table.insert( self.dirty_flags, DirtyFlags.NEW_LINES )
    end

    if ( self.log_lines:Size() > 500 ) then
        self.log_lines:Pop()
    end

    self.log_lines:Push( LogLine:New( logLevel, GetTimeString(), fmt:format( ... ) ) )
end

--- Log something under info channel
-- @tparam string fmt
-- @param ...
function Console:LogInfo( fmt, ... )
    self:Log( LogLevels.INFO, fmt, ... )
end

--- Log something under warning channel
-- @tparam string fmt
-- @param ...
function Console:LogWarning( fmt, ... )
    self:Log( LogLevels.WARNING, fmt, ... )
end

--- Log something under error channel
-- @tparam string fmt
-- @param ...
function Console:LogError( fmt, ... )
    self:Log( LogLevels.ERROR, fmt, ... )
end

--- Log something under debug channel
-- @tparam string fmt
-- @param ...
function Console:LogDebug( fmt, ... )
    self:Log( LogLevels.DEBUG, fmt, ... )
end

--- Set maximum log level severity
-- @tparam LogLevels level
function Console:SetLogLevel( level )
    self.log_level = level 
    table.insert( self.dirty_flags, DirtyFlags.FILTER_CHANGED )
end 

--- Initialize the console in global space
-- @tparam table self
function Pky_Console_Initialized( self )
    CONSOLE = Console:New( self )
    SLASH_COMMANDS['/console']  = function( ... ) CONSOLE:Show() end
    SLASH_COMMANDS['/d']        = function( ... ) CONSOLE:Show() end
end