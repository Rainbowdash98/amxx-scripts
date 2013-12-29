/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>
#include <fakemeta>
#include <fakemeta_util>
#include <engine>
#include <xs>
#include <codmod>

#define VERSION "1.0"
#define AUTHOR "DarkGL"

#define MAX 20

#define TIME_SHOT 2.5
#define RANGE 100.0
#define DAMAGE 50.0

#define write_coord_f(%0)  ( engfunc( EngFunc_WriteCoord, %0 ) )

new const v_model[] 	= 	"models/v_palec.mdl";
new const iWeapon	= 	CSW_KNIFE;
new const szWeapon[]	= 	"weapon_knife";

new Float:fShot[MAX + 1];

new gmsgShake

new gLaserSprite;

new bool:ma_perk[MAX + 1]

public plugin_init() {
	register_plugin("Elektryczna Rekawiczka", VERSION, AUTHOR)
	
	cod_register_perk("Rekawiczka Excela", "Mozesz strzelac piorunami (Wyjmij noz)");
	
	RegisterHam(Ham_Item_Deploy,szWeapon,"fwDeploy",1)
	RegisterHam(Ham_Spawn,"player","fwSpawned",1)
	
	register_forward(FM_PlayerPreThink, "PlayerPreThink")
	register_forward(FM_UpdateClientData, "UpdateClientData_Post", 1)
	
	gmsgShake = get_user_msgid("ScreenShake");
}

public plugin_precache(){
	precache_model(v_model)
	
	gLaserSprite = precache_model("sprites/laserbeam.spr")
	
	//precache_sound("palec_zeusa/thunder.wav")
}

public client_connect(id){
	fShot[id] = get_gametime();
}

public fwSpawned(id){
	if(!is_user_alive(id) || !ma_perk[id])
		return HAM_IGNORED;
	
	fm_give_item(id,szWeapon);
	
	return HAM_IGNORED;
}

public cod_perk_enabled(id){
	
	if(cod_get_user_class(id) == cod_get_classid("Jozek"))
		return COD_STOP;
		
	//fm_give_item(id, szWeapon);
	
	ma_perk[id] = true;
	
	return COD_CONTINUE;
}

public cod_perk_disabled(id){
	
	ma_perk[id] = false;
}

public fwDeploy(wpn){
	static iOwner;
	iOwner = pev(wpn,pev_owner);
	
	if(!is_user_alive(iOwner) || !ma_perk[iOwner])
		return ;
	
	set_pev(iOwner,pev_viewmodel2,v_model)
	
	setWeaponAnim(iOwner,5);
}

public PlayerPreThink( id )
{
	if( !is_user_alive(id) || get_user_weapon(id) != iWeapon || !ma_perk[id])
		return FMRES_IGNORED;
	
	new buttons = pev(id,pev_button);
	new oldbuttons = pev(id,pev_oldbuttons)
	
	if(buttons & IN_ATTACK && !(oldbuttons & IN_ATTACK) && fShot[id] <= get_gametime()){
		
		fShot[id] = get_gametime() + TIME_SHOT;
		
		new Float:fOrigin[3],Float:fView[3],Float:fAngles[3]
		
		pev(id,pev_origin,fOrigin)
		pev(id,pev_view_ofs,fView);
		
		xs_vec_add(fOrigin,fView,fOrigin);
		
		pev(id,pev_v_angle,fAngles);
		angle_vector(fAngles,ANGLEVECTOR_FORWARD,fAngles);
		
		xs_vec_mul_scalar(fAngles,999.0,fAngles);
		
		xs_vec_add(fOrigin,fAngles,fAngles);
		
		new ptr = create_tr2()
		
		engfunc(EngFunc_TraceLine,fOrigin,fAngles,DONT_IGNORE_MONSTERS,id,ptr)
		
		new Float:fEnd[3];
		get_tr2(ptr,TR_vecEndPos,fEnd)
		
		new pHit = get_tr2(ptr,TR_pHit)
		
		free_tr2(ptr);
		
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
		write_byte (TE_BEAMENTPOINT)
		write_short(id | 0x1000)
		/*write_byte( TE_BEAMPOINTS  )
		write_coord_f( fOrigin[0] );
		write_coord_f( fOrigin[1] );
		write_coord_f( fOrigin[2] );*/
		write_coord_f( fEnd[0] );
		write_coord_f( fEnd[1] );
		write_coord_f( fEnd[2] );
		write_short( gLaserSprite );
		write_byte( 255 );    //Start frame 0 
		write_byte( 255 );    //Frame rate 0
		write_byte( 3 );    //Life 10
		write_byte( 10);    //Width 20
		write_byte( 30);    //noise 300
		write_byte( 0 );    //R
		write_byte( 127 );    //G
		write_byte( 255 );    //B
		write_byte( 255 );    //brightness 200
		write_byte( 5 );    //Scroll 30
		message_end();        //End
		
		setWeaponAnim(id,random_num(1,3));
		
		message_begin(MSG_ONE, gmsgShake, {0,0,0}, id)
		write_short(255<< 14 ) //ammount 
		write_short((1<<12)) //lasts this long 
		write_short(255<< 14) //frequency 
		message_end() 
		
		//emit_sound(id,CHAN_VOICE,"palec_zeusa/thunder.wav",VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		
		if(is_user_alive(pHit) && get_user_team(pHit) != get_user_team(id)){
			
			message_begin(MSG_ONE, gmsgShake, {0,0,0}, pHit)
			write_short(255<< 14 ) //ammount 
			write_short((1<<12)) //lasts this long 
			write_short(255<< 14) //frequency 
			message_end() 
			
			new bool:bAttacked[MAX + 1];
			
			bAttacked[pHit] = true;
			
			cod_inflict_damage(id,pHit,DAMAGE,1.0)
			set_hudmessage(255, 255, 255, -1.0, -1.00, 2, 6.0, 0.4, 0.00, 0.39, -1)
			show_hudmessage(id, "X")
			Display_Fade(pHit,(1<<12),(1<<12),0x0000,0,127,255,200);
			
			new Array:iFinded = ArrayCreate(1,1);
			ArrayPushCell(iFinded,pHit);
			
			new iPos = 0;
			
			while(ArraySize(iFinded) > iPos){
				new Float:fOriginTmp[3];
				pev(ArrayGetCell(iFinded,iPos),pev_origin,fOriginTmp);
				
				new iEnt = -1
				
				while((iEnt = find_ent_in_sphere(iEnt,fOriginTmp,RANGE)) != 0){
					if(is_user_alive(iEnt) && get_user_team(iEnt) != get_user_team(id) && !bAttacked[iEnt]){
						bAttacked[iEnt] = true;
						
						ArrayPushCell(iFinded,iEnt);
						
						cod_inflict_damage(id,iEnt,DAMAGE,1.0)
						set_hudmessage(255, 255, 255, -1.0, -1.00, 2, 6.0, 0.4, 0.00, 0.39, -1)
						show_hudmessage(id, "X")
						Display_Fade(iEnt,(1<<12),(1<<12),0x0000,0,127,255,200);
						
						message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
						write_byte(TE_BEAMENTS)
						write_short(ArrayGetCell(iFinded,iPos))
						write_short(iEnt)
						write_short( gLaserSprite );
						write_byte( 255 );    //Start frame 0 
						write_byte( 255 );    //Frame rate 0
						write_byte( 3 );    //Life 10
						write_byte( 10);    //Width 20
						write_byte( 30);    //noise 300
						write_byte( 0 );    //R
						write_byte( 127 );    //G
						write_byte( 255 );    //B
						write_byte( 255 );    //brightness 200
						write_byte( 5 );    //Scroll 30
						message_end();        //End
						
						message_begin(MSG_ONE, gmsgShake, {0,0,0}, iEnt)
						write_short(255<< 14 ) //ammount 
						write_short((1<<12)) //lasts this long 
						write_short(255<< 14) //frequency 
						message_end() 
					}
				}
				iPos++;
			}
			
			ArrayDestroy(iFinded)
		}
	}
	
	buttons = buttons & ~IN_ATTACK;
	buttons = buttons & ~IN_ATTACK2;
	
	set_pev( id, pev_button, buttons );
	
	return FMRES_HANDLED;
}

public UpdateClientData_Post( id, sendweapons, cd_handle )
{
	
	if ( !is_user_alive(id) || get_user_weapon(id) != iWeapon || !ma_perk[id])
		return FMRES_IGNORED;
	
	set_cd(cd_handle, CD_flNextAttack, halflife_time() + 0.001 );
	return FMRES_HANDLED;
}

stock setWeaponAnim(id, anim) {
	set_pev(id, pev_weaponanim, anim)
	
	message_begin(MSG_ONE, SVC_WEAPONANIM, {0, 0, 0}, id)
	write_byte(anim)
	write_byte(pev(id, pev_body))
	message_end()
} 

stock Display_Fade(id,duration,holdtime,fadetype,red,green,blue,alpha)
{
	if(!is_user_alive(id)){
		return ;
	}
	message_begin( MSG_ONE, get_user_msgid("ScreenFade"),{0,0,0},id );
	write_short( duration );        // Duration of fadeout
	write_short( holdtime );        // Hold time of color
	write_short( fadetype );        // Fade type
	write_byte ( red );             // Red
	write_byte ( green );           // Green
	write_byte ( blue );            // Blue
	write_byte ( alpha );   // Alpha
	message_end();
}
