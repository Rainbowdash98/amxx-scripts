/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <codmod>
#include <fun>

#define TASK_WYSZKOLENIE_SANITARNE 716
#define MAX 20

new const perk_name[] = "Kokaina";
new const perk_desc[] = "Regenerujesz swoje zycie z kazda sekunda";

new bool:ma_perk[MAX+1];

public plugin_init() 
{
	register_plugin(perk_name, "1.0", "QTM_Peyote");
	
	cod_register_perk(perk_name, perk_desc);
}

public cod_perk_enabled(id)
{
	ma_perk[id] = true;
	set_task(1.0, "WyszkolenieSanitarne", id+TASK_WYSZKOLENIE_SANITARNE);
}

public cod_perk_disabled(id)
	ma_perk[id] = false;

public WyszkolenieSanitarne(id)
{
	id -= TASK_WYSZKOLENIE_SANITARNE;
	
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE;
		
	if(ma_perk[id])
	{
		set_task(1.0, "WyszkolenieSanitarne", id+TASK_WYSZKOLENIE_SANITARNE);
		
		if(is_user_alive(id))
		{
			new cur_health = get_user_health(id);
			new max_health = 100+cod_get_user_health(id);
			new new_health = cur_health+1<max_health? cur_health+1: max_health;
			set_user_health(id, new_health);
		}
	}
	return PLUGIN_CONTINUE;
}
