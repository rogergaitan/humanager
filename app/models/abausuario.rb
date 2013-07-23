# == Schema Information
#
# Table name: abausuarios
# NUSR 						:varchar(15) (T_IUSUARIO)
# BMASTER 					:char(1) (T_BOOLEAN)
# SGRUPOUSR 				:varchar(6) (T_GRUPOUSUARIO)
# SNOMBRE 					:varchar(80) (T_NOMBRETERCERO)
# BCAJEROTURNOS 			:char(1) (T_BOOLEAN)
# BFILTRAROPR 				:char(1) (T_BOOLEAN)
# SPASSWORD 				:varchar(10)
# ITDCONECT 				:char(1)
# IPERFIL 					:varchar(15) (T_IPERFILSEGURIDAD)
# BPASSWORDMODIFY 			:char(1) (T_BOOLEAN)
# FDATECREATE 				:date (T_FECHA)
# FDATEEXPIRED 				:date (T_FECHA)
# ILICENCIASVRT 			:blob sub_type 1 (T_MEMO)
# IWS 						:varchar(15) (T_IWS)
# TELEFONO 					:varchar(30) (T_TELEFONO)
# FCREACION 				:timestamp (T_FECHAHORA)
# SKYPE 					:varchar(30)
# IWSULT 					:varchar(15) (T_IWS)
# FULTIMA 					:timestamp (T_FECHAHORA)
# IUSUARIO 					:varchar(15) (T_IUSUARIO)
# IUSUARIOULT 				:varchar(15) (T_IUSUARIO)
# SEMAIL 					:varchar(80) (T_EMAIL)
# SAPELLIDO 				:varchar(30)
# CELULAR 					:varchar(30) (T_TELEFONO)
# BREQUIEREACTUALIZAR 		:char(1) (T_BOOLEAN)
# BREGISTROWEB 				:char(1) (T_BOOLEAN)

# -*- encoding : utf-8 -*-
class Abausuario < ActiveRecord::Base
	set_table_name 'ABAUSUARIOS'
	establish_connection :firebird
	attr_accessible :nusr, :snombre, :spassword, :semail

end
