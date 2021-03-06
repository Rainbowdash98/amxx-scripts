/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>
#include <achievements>
#include <cstrike>
#include <csx>
#include <codmod>
#include <dhudmessage>

#define PLUGIN "Achy Main"
#define VERSION "0.5"
#define AUTHOR "ToRRent"
new uch_celownik, /*uch_siewca, */uch_saper, uch_wrog, uch_boom, uch_nieudacz, uch_ciota, uch_mieso, uch_niewiar, uch_7, uch_dni, uch_lampion, uch_pan, uch_cien, uch_nozow, uch_snajper, uch_zabojca, uch_shotgun, uch_lekki, uch_ciezki, uch_krowa;

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	uch_celownik = ach_add("Latajacy Celownik", "Traf 500 razy w glowe", 500);
	//uch_siewca = ach_add("Siewca Mordu", "Zadaj 100 000 obrazen wrogom", 100000);
	uch_saper = ach_add("Saper", "Rozbroj 250 bomb", 250);
	uch_wrog = ach_add("Wrog Publiczny", "Podloz 250 bomb", 250);
	uch_boom = ach_add("Ka-Boom", "Zdetonuj 200 bomb", 200);
	uch_nieudacz = ach_add("Nieudacznik", "Zdetonuj 100 bomb podczas rozbrajania", 100);
	uch_ciota = ach_add("Ciota", "Zgin 150 raazy", 150);
	uch_mieso = ach_add("Mieso Armatnie", "Otrzymaj 100 000 obrazen", 100000);
	uch_niewiar = ach_add("Niewiarygodne I", "Zabij wroga headshotem z HE", 1);
	//uch_niewiar2 = ach_add("Niewiarygodne II", "Zabij wroga headshotem za pomoca noza", 1);
	uch_7 = ach_add("7 zyc", "Zabij 7 wrogow majac mniej niz 10 HP", 7);
	uch_dni = ach_add("Stare Dobre Dni", "Nabij 50 fragow na 1 mapie", 50);
	uch_lampion = ach_add("Zywy Lampion", "Uzyj 1000 razy latarki", 1000);
	uch_pan = ach_add("Pan Smierci", "wystrzel 1 000 000 naboi", 1000000);
	uch_cien = ach_add("W cieniu", "Przezyj 3 rundy z rzedu", 3);
	uch_nozow = ach_add("Mlody Nozownik", "Zabij 50 graczy nozem", 50);
	uch_snajper = ach_add("Snajper-Wymiatacz", "Zabij 150 graczy ze snajperek", 150);
	uch_zabojca = ach_add("Podreczny Zabojca", "Zabij 200 graczy za pomoca pistoletow", 200);
	uch_shotgun = ach_add("Expert Shotguna", "Zabij 100 graczy za pomoca shotguna", 100);
	uch_lekki = ach_add("Lekki Szturmowiec", "Zabij 300 graczy za pomoca SMG", 300);
	uch_ciezki = ach_add("Ciezki Szturmowiec", "Zabij 500 graczy za pomoca broni szturmowych", 500);
	uch_krowa = ach_add("Pogromca Krowy", "Zabij 250 graczy za pomoca M249", 250);
	
	RegisterHam(Ham_Killed, "player", "HamCheck", 1);
	register_forward(FM_TraceLine, "fw_traceline");
	RegisterHam(Ham_TakeDamage, "player", "HamTakeDamage", 1);
	register_logevent("Koniec_Rundy", 2, "1=Round_End")
}

public plugin_end() 
{
	for(new i=0; i<32; i++)
	{
		if(is_user_connected(i) && ach_get_stance(i, uch_dni) == 0)
			ach_reset_status(i, uch_dni)
	}
}

public HamCheck(id)
{
	new ach14stats[8],ach14body[8];
	get_user_rstats(id, ach14stats, ach14body);
	if(ach_get_stance(id, uch_pan) == 0)
		ach_add_status(id, uch_pan, ach14stats[4]);
}

public fw_traceline(Float:vecStart[3],Float:vecEnd[3],ignoreM,id,trace)
{
	if(!is_user_connected(id))
		return;
	
	new hit = get_tr2(trace, TR_pHit);
	
	if(!is_user_connected(hit))
		return;
	
	new hitzone = get_tr2(trace, TR_iHitgroup);
	if(hitzone == HIT_HEAD && ach_get_stance(id, uch_celownik) == 0 )
		ach_add_status(id, uch_celownik, 1)
	
}

public HamTakeDamage(this, idinflictor, idattacker, Float:damage, damagebits)
{
	new ClassThis[12];
	pev(this, pev_classname, ClassThis, 11)
	
	if(equal(ClassThis, "player"))
	{
		//ach_add_status(idattacker, uch_siewca, floatround(damage, floatround_round));
		if(ach_get_stance(this, uch_mieso) == 0)
			ach_add_status(this, uch_mieso, floatround(damage, floatround_round));
	}
}

public client_impulse(id, impulse)
{
	if(impulse == 100)
	{
		if(is_user_alive(id) && is_user_connected(id) && ach_get_stance(id, uch_lampion) == 0)
		{
			static Float:Last[33];
			new Float:Now = get_gametime();
			if((Now - Float:Last[id]) >= 2.0)
			{          
				ach_add_status(id, uch_lampion, 1);
				Last[id] = Now;
			}

		}
	}


}

public bomb_defused(defuser)
{
	if(is_user_connected(defuser) && ach_get_stance(defuser, uch_saper) == 0)
		ach_add_status(defuser, uch_saper, 1);
}
public bomb_planted(planter)
{
	if(is_user_connected(planter) && ach_get_stance(planter, uch_wrog) == 0)
		ach_add_status(planter, uch_wrog, 1);
}
public bomb_explode(planter,defuser)
{
	if(is_user_connected(planter) && ach_get_stance(planter, uch_boom) == 0)
		ach_add_status(planter, uch_boom, 1);
	if(is_user_connected(defuser) && ach_get_stance(defuser, uch_nieudacz) == 0)
		ach_add_status(defuser, uch_nieudacz, 1);
}

public client_death(killer, victim, wpnindex, hitplace)
{
	if(ach_get_stance(victim, uch_cien) == 0)
		ach_reset_status(victim, uch_cien)
	
	if(killer != victim)
	{
		if(ach_get_stance(victim, uch_ciota) == 0)
			ach_add_status(victim, uch_ciota, 1);
		
		if(ach_get_stance(killer, uch_dni) == 0)
			ach_add_status(killer, uch_dni, 1);
		
		if(wpnindex == CSW_KNIFE && ach_get_stance(killer, uch_nozow) == 0)
			ach_add_status(killer, uch_nozow, 1);

		if(get_user_health(killer) <= 10 && ach_get_stance(killer, uch_7) == 0)
			ach_add_status(killer, uch_7, 1);
		
		if(wpnindex == CSW_HEGRENADE && hitplace == HIT_HEAD && ach_get_stance(killer, uch_niewiar) == 0)
			ach_set_status(killer, uch_niewiar, 1);
	
		if((wpnindex == CSW_SCOUT || wpnindex == CSW_AWP || wpnindex == CSW_SG550 || wpnindex == CSW_G3SG1) && ach_get_stance(killer, uch_snajper) == 0)
			ach_add_status(killer, uch_snajper, 1);
	
		if((wpnindex == CSW_GLOCK18 || wpnindex == CSW_USP || wpnindex == CSW_FIVESEVEN || wpnindex == CSW_DEAGLE || wpnindex == CSW_ELITE) && ach_get_stance(killer, uch_zabojca) == 0)
			ach_add_status(killer, uch_zabojca, 1);
		
		if((wpnindex == CSW_M3 || wpnindex == CSW_XM1014) && ach_get_stance(killer, uch_shotgun) == 0)
			ach_add_status(killer, uch_shotgun, 1);
	
		if((wpnindex == CSW_TMP || wpnindex == CSW_MAC10 || wpnindex == CSW_MP5NAVY || wpnindex == CSW_UMP45 || wpnindex == CSW_P90) && ach_get_stance(killer, uch_lekki) == 0)
			ach_add_status(killer, uch_lekki, 1);
		
		if((wpnindex == CSW_GALIL || wpnindex == CSW_AK47 || wpnindex == CSW_SG552 || wpnindex == CSW_FAMAS || wpnindex == CSW_M4A1 || wpnindex == CSW_AUG) && ach_get_stance(killer, uch_ciezki) == 0)
			ach_add_status(killer, uch_ciezki, 1);
		
		if(wpnindex == CSW_M249 && ach_get_stance(killer, uch_krowa) == 0)
			ach_add_status(killer, uch_krowa, 1);	
	}
}

public Koniec_Rundy()
{
	for(new i=1; i<32; i++)
	{
		if(is_user_connected(i))
		{
			if(is_user_alive(i) && ach_get_stance(i, uch_cien) == 0)
				ach_add_status(i, uch_cien, 1);
		}	
	}
}
// wynagrodzenie cod nowy
public ach_give_reward(pid, aid)
{
	if(ach_get_stance(pid, uch_celownik) == 1)
	{
		//ach_set_stance(pid, uch_celownik, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+150);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+150");
	}
	/*if(ach_get_stance(pid, uch_siewca) == 1)
	{
		ach_set_stance(pid, uch_siewca, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+200);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+200");
	}*/
	if(ach_get_stance(pid, uch_saper) == 1)
	{
		//ach_set_stance(pid, uch_saper, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+200);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+200");
	}
	if(ach_get_stance(pid, uch_wrog) == 1)
	{
		//ach_set_stance(pid, uch_wrog, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+250);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+250");
	}
	if(ach_get_stance(pid, uch_boom) == 1)
	{
		//ach_set_stance(pid, uch_boom, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+100);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+100");
	}
	if(ach_get_stance(pid, uch_nieudacz) == 1)
	{
		//ach_set_stance(pid, uch_nieudacz, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+50);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+50");
	}
	if(ach_get_stance(pid, uch_ciota) == 1)
	{
		//ach_set_stance(pid, uch_ciota, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+75);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+75");
	}
	if(ach_get_stance(pid, uch_nozow) == 1)
	{
		//ach_set_stance(pid, uch_nozow, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+150);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+150");
	}
	if(ach_get_stance(pid, uch_mieso) == 1)
	{
		//ach_set_stance(pid, uch_mieso, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+150);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+150");
	}
	if(ach_get_stance(pid, uch_niewiar) == 1)
	{
		//ach_set_stance(pid, uch_niewiar, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+50);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+50");
	}
	if(ach_get_stance(pid, uch_7) == 1)
	{
		//ach_set_stance(pid, uch_7, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+150);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+150");
	}
	if(ach_get_stance(pid, uch_dni) == 1)
	{
		//ach_set_stance(pid, uch_dni, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+200);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+200");
	}
	if(ach_get_stance(pid, uch_lampion) == 1)
	{
		//ach_set_stance(pid, uch_lampion, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+100);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+100");
	}
	if(ach_get_stance(pid, uch_pan) == 1)
	{
		//ach_set_stance(pid, uch_pan, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+200);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+200");
	}
	if(ach_get_stance(pid, uch_cien) == 1)
	{
		//ach_set_stance(pid, uch_cien, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+50);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+50");
	}
	if(ach_get_stance(pid, uch_snajper) == 1)
	{
		//ach_set_stance(pid, uch_snajper, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+150);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+150");
	}
	if(ach_get_stance(pid, uch_zabojca) == 1)
	{
		//ach_set_stance(pid, uch_zabojca, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+200);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+200");
	}
	if(ach_get_stance(pid, uch_shotgun) == 1)
	{
		//ach_set_stance(pid, uch_shotgun, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+100);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+100");
	}
	if(ach_get_stance(pid, uch_lekki) == 1)
	{
		//ach_set_stance(pid, uch_lekki, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+300);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+300");
	}
	if(ach_get_stance(pid, uch_ciezki) == 1)
	{
		//ach_set_stance(pid, uch_ciezki, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+500);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+500");
	}
	if(ach_get_stance(pid, uch_krowa) == 1)
	{
		//ach_set_stance(pid, uch_krowa, 1)
		cod_set_user_xp(pid, cod_get_user_xp(pid)+250);
		COD_MSG_EXP_N;
		show_dhudmessage(pid, "+250");
	}
}
