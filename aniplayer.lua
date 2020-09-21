--[[
    Requires VGUI Construction
    ## https://github.com/cresterienvogel/VGUI-Construction
]]

if CLIENT then
    local color_bg = Color(102, 102, 102)
    local color_top = Color(250, 250, 250)

    local color_btn_depressed = Color(128, 0, 0)
    local color_btn_hovered = Color(255, 0, 0)

    construction.Register("AniPlayer", {
        {
            type = "EditablePanel",
            init = function(pnl)
                pnl:Dock(FILL)
                pnl:MakePopup()

                pnl.Paint = function(self, w, h)
                    surface.SetDrawColor(color_bg)
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
                            surface.SetDrawColor(color_top)
                            surface.DrawRect(0, 0, w, h)
                        end
                    end,
                    children = {
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
                                        self:SetColor(color_white)
                                        surface.SetDrawColor(color_btn_depressed)
                                        surface.DrawRect(0, 0, w, h)
                                    elseif self.Hovered then
                                        self:SetColor(color_white)
                                        surface.SetDrawColor(color_btn_hovered)
                                        surface.DrawRect(0, 0, w, h)
                                    else
                                        self:SetColor(color_black)
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
