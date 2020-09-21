--[[
    Requires VGUI Construction
    ## https://github.com/cresterienvogel/VGUI-Construction
]]

if CLIENT then
    surface.CreateFont("aniplayer_1", {size = 22, weight = 300, antialias = true, extended = true, font = "Tahoma"})

    construction.Register("AniPlayer", {
        {
            type = "EditablePanel",
            init = function(pnl)
                pnl:SetPos(0, 0)
                pnl:SetSize(ScrW(), ScrH())
                pnl:MakePopup()

                pnl.Paint = function(self, w, h)
                    surface.SetDrawColor(102, 102, 102)
                    surface.DrawRect(0, 0, w, h)
                end
            end,
            children = {
                {
                    type = "EditablePanel",
                    init = function(pnl)
                        pnl:SetTall(30)
                        pnl:Dock(TOP)
                        pnl:DockPadding(12, 0, 0, 0)
                        pnl.Paint = function(_, w, h)
                            surface.SetDrawColor(color_white)
                            surface.DrawRect(0, 0, w, h)
                        end
                    end,
                    children = {
                        {
                            type = "DLabel",
                            init = function(pnl)
                                pnl:SetTextColor(color_black)
                                pnl:SetContentAlignment(4)
                                pnl:SetFont("aniplayer_1")
                                pnl:SetColor(color_black)
                                pnl:SetText("AniPlayer")
                                pnl:SizeToContents()
                                pnl:Dock(LEFT)
                            end
                        },
                        {
                            type = "DButton",
                            init = function(pnl)
                                pnl:SetText("r")
                                pnl:Dock(RIGHT)
                                pnl:SetWide(50)
                                pnl:SetColor(color_black)
                                pnl:SetFont("Marlett")

                                pnl.Paint = function(self, w, h)
                                    if self.Depressed then
                                        surface.SetDrawColor(128, 0, 0)
                                        surface.DrawRect(0, 0, w, h)
                                    elseif self.Hovered then
                                        surface.SetDrawColor(255, 0, 0)
                                        surface.DrawRect(0, 0, w, h)
                                    end
                                end

                                pnl.DoClick = function(self)
                                    self:GetParent():GetParent():Remove()
                                end
                            end
                        }
                    }
                },
                {
                    type = "DPanel",
                    init = function(pnl)
                        pnl:Dock(FILL)
                        pnl:DockMargin(12, 12, 12, 12)
                    end,
                    children = {
                        {
                            type = "DHTML",
                            init = function(pnl)
                                dhtml = pnl
                                pnl:Dock(FILL)
                                pnl:OpenURL("https://xenpare.com/aniplayer")
                            end
                        }
                    }
                }
            }
        }
    })

    concommand.Add("aniplayer", function()
        construction.Create("AniPlayer")
    end)
else
    hook.Add("PlayerSay", "AniPlayer", function(pl, text)
        if string.lower(text) == "/aniplayer" then
            pl:ConCommand("aniplayer")
            return ""
        end
    end)
end