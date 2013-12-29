/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <hamsandwich>
#include <codmod>

#define ZADANIE_WSKRZES 6940

new const perk_name[] = "Morfina";
new const perk_desc[] = "Masz 1/LW szans na odrodzenie sie po smierci";

#define MAX 20
new wartosc_perku[MAX + 1];
new bool:ma_perk[MAX + 1];
new bool:wskrzesony[MAX + 1];

public plugin_init()
 {
	register_plugin(perk_name, "1.0", "QTM_Peyote");
	
	cod_register_perk(perk_name, perk_desc, 2, 4);
	RegisterHam(Ham_Killed, "player", "Killed", 1);
	RegisterHam(Ham_Spawn, "player", "Spawn", 1);
}

public cod_perk_enabled(id, wartosc)
{
	wartosc_perku[id] = wartosc;
	ma_perk[id] = true;
}

public cod_perk_disabled(id)
	ma_perk[id] = false;

public Killed(id)
{
	if(ma_perk[id] && random_num(1, wartosc_perku[id]) == 1)
	{
		set_task(0.5, "Wskrzes", id+ZADANIE_WSKRZES);
	}
}

public Wskrzes(id)
{
	ExecuteHamB(Ham_CS_RoundRespawn, id-ZADANIE_WSKRZES);
	wskrzesony[id-ZADANIE_WSKRZES] = true;
}

public Spawn(id)
{
	if(wskrzesony[id] && is_user_alive(id))
	{
		COD_MSG_SKILL_D;
		show_hudmessage(id, "Zostales wskrzeszony dzieki perkowi Morfina");
		Display_Fade(id, 1<<12, 2<<12, 1<<16, 255, 255, 255, 175);
		Display_Icon(id,1,"dmg_shock",255,255,255);
		wskrzesony[id] = false
	}
}
		

stock Display_Fade(id,duration,holdtime,fadetype,red,green,blue,alpha)
{
	message_begin(MSG_ONE, get_user_msgid("ScreenFade"),{0,0,0},id);
	write_short(duration);
	write_short(holdtime);
	write_short(fadetype);
	write_byte(red);
	write_byte(green);
	write_byte(blue);
	write_byte(alpha);
	message_end();
}

stock Display_Icon(id, enable, name[], red, green, blue) {
	static g_iMsg;
	if(!g_iMsg)
		g_iMsg = get_user_msgid("StatusIcon")
	
	if(!is_user_connected(id)) return ;
	
	message_begin(!id ? MSG_ALL : MSG_ONE, g_iMsg, {0,0,0}, id);
	write_byte(enable);
	write_string(name);
	write_byte(red);
	write_byte(green);
	write_byte(blue);
	message_end();
}	
