_addon.name = 'OmenTracker'
_addon.author = 'from20020516'
_addon.version = '1.1'
_addon.language = 'Japanese'

config = require('config')
defaults = {posx=15,posy=370,font='Meiryo UI',fontsize=12}
settings = config.load(defaults)
id = 0.666

windower.register_event('incoming text',function(original,_,mode)
    local shift_jis = windower.from_shift_jis(original)
    if mode == 161 then
        local pattern = '^[1-9].*(せ。|せよ。|え。|！！|なかった……。)'
        if windower.regex.match(shift_jis,pattern) then
            local i,value = unpack(windower.regex.split(windower.regex.match(shift_jis,pattern)[1][0],":"))
            local value = windower.regex.match(value,"なかった……。|！！") and '' or value
            text.set_text(i+id,i..':'..value)
        elseif windower.regex.match(shift_jis,'せ。|た。') then
            text.set_text(0+id,shift_jis)
        elseif windower.regex.match(shift_jis,'モンスターから666の兆しを見た！！') then
            text.set_color(0+id,200,unpack({255,183,76}))
            text.set_text(0+id,'モンスターから666の兆しを見た！！')
        end
    end
end)

windower.register_event('status change',function(new,old)
    if new == 4 then --warp
        initializer()
    end
end)

function initializer()
    text = windower.text
    local s = settings
    for i=0,10 do
        text.create(i+id)
        text.set_text(i+id,i..':')
        local i = i+id
        text.set_location(i,s.posx,s.posy+i*s.fontsize*2)
        text.set_color(i,200,unpack({255,255,255}))
        text.set_font(i,s.font,'Meiryo')
        text.set_font_size(i,s.fontsize)
        text.set_stroke_width(i,2)
        text.set_stroke_color(i,200,0,0,0)
    end
    text.set_text(0+id,_addon.name)
end
windower.register_event('load',initializer)
