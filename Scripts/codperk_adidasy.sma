/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <codmod>

new nazwa[] = "Adidaski"
new opis[] = "Dostajesz 30 kondycji"

public plugin_init() 
{
	register_plugin(nazwa, "1.0", "QTM_Peyote");
	
	cod_register_perk(nazwa, opis);
}

public cod_perk_enabled(id)	
	cod_set_user_bonus_trim(id, cod_get_user_trim(id, 0, 0)+30);

public cod_perk_disabled(id)
	cod_set_user_bonus_trim(id, cod_get_user_trim(id, 0, 0)-30);

