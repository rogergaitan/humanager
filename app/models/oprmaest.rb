# == Schema Information
#
# Table name: OPRMAEST
#
# PK IEMP 					:smallint (T_IEMP)				not null
# PK INUMOPER 				:integer (T_INUMOPER)			not null
# FSOPORT 					:date (T_FECHA)					not null
# ITDOPER 					:varchar(4) (T_ITDOPER)
# ITDSOP 					:smallint (T_ITDSOP)
# INUMSOP 					:integer
# SNUMSOP 					:varchar(20) (T_NUMSOP)
# ICLASIFOP 				:smallint (T_ITDABADTIT)
# FANIO 					:smallint (T_FANIO)
# FMES 						:smallint (T_FMES)
# FDIA 						:smallint (T_FDIA)
# FSEMANA 					:smallint (T_FSEMANA)
# TDETALLE 					:varchar(100)
# ICCBASE 					:varchar(20) (T_ICC)
# IMONEDA 					:varchar(5) (T_IMONEDA)
# ISEDE 					:varchar(20) (T_ICC)
# IUSUARIOULT 				:varchar(15) (T_IUSUARIO)
# INIT 						:varchar(20) (T_INIT)
# IPROCESS 					:smallint
# IESTADO 					:smallint
# INUMOPERULTIMP 			:integer (T_INUMOPER)
# FPROCESAM 				:timestamp (T_FECHAHORA)
# QERROR 					:smallint (T_CANT_ENTEROS)
# QWARNING 					:smallint (T_CANT_ENTEROS)
# BUSRDETAIL 				:char(1) (T_BOOLEAN)			DEFAULT 'F'
# BNODESPROCESO 			:char(1) (T_BOOLEAN)			DEFAULT 'F'
# BANULADA 					:char(1) (T_BOOLEAN)			DEFAULT 'F'
# BIMPRESA 					:char(1) (T_BOOLEAN)			DEFAULT 'F'
# QIMPRESIONES 				:smallint (T_QCOPIASIMPRESION)
# MINGRESOS 				:numeric(18,4) (T_MONETARIO)
# MEGRESOS 					:numeric(18,4) (T_MONETARIO)
# MDEBITOS 					:numeric(18,4) (T_MONETARIO)
# MCREDITOS 				:numeric(18,4) (T_MONETARIO)
# QMOVCNT 					:integer
# QMOVINV 					:integer
# QMOVORD 					:integer
# ZLOG 						:blob sub_type 0
# ZCOMENTAR 				:blob sub_type 1 (T_MEMO)
# IDRVVERSION 				:smallint
# IIMAGEN 					:smallint
# IRELEASE 					:float
# SGRUPOUSR 				:varchar(6) (T_GRUPOUSUARIO)
# ITDFORMATOPRINTED 		:smallint (T_ITDFORMATO)
# FCREACIONUSR 				:timestamp (T_FECHAHORA)
# INUMOPERV3 				:integer (T_INUMOPER)
# IWS 						:varchar(15) (T_IWS)
# FCREACION 				:timestamp (T_FECHAHORA)
# IWSULT 					:varchar(15) (T_IWS)
# FULTIMA 					:timestamp (T_FECHAHORA)
# IUSUARIO 					:varchar(15) (T_IUSUARIO)
# IEJECUCION 				:integer
# BMOVMANUAL 				:char(1) (T_BOOLEAN)			DEFAULT 'F'
# ISUCURSAL 				:varchar(6)

# -*- encoding : utf-8 -*-
class Oprmaest < ActiveRecord::Base
	establish_connection :firebird
	# attr_accessible :IEMP, :INUMOPER, :FSOPORT, :ITDOPER, :ITDSOP, :INUMSOP, :SNUMSOP, 
	# :ICLASIFOP, :FANIO, :FMES, :FDIA, :FSEMANA, :TDETALLE, :ICCBASE, :IMONEDA, :ISEDE, 
	# :IUSUARIOULT, :INIT, :IPROCESS, :IESTADO, :INUMOPERULTIMP, :FPROCESAM, :QERROR, 
	# :QWARNING, :BUSRDETAIL, :BNODESPROCESO, :BANULADA, :BIMPRESA, :QIMPRESIONES, :MINGRESOS, 
	# :MEGRESOS, :MDEBITOS, :MCREDITOS, :QMOVCNT, :QMOVINV, :QMOVORD, :ZLOG, :ZCOMENTAR, 
	# :IDRVVERSION, :IIMAGEN, :IRELEASE, :SGRUPOUSR, :ITDFORMATOPRINTED, :FCREACIONUSR, 
	# :INUMOPERV3, :IWS, :FCREACION, :IWSULT, :FULTIMA, :IUSUARIO, :IEJECUCION, :BMOVMANUAL, 
	# :ISUCURSAL
	attr_accessible :iemp, :inumoper, :fsoport, :itdoper, :itdsop, :inumsop, :snumsop, 
	:iclasifop, :fanio, :fmes, :fdia, :fsemana, :tdetalle, :iccbase, :imoneda, :isede, 
	:iusuarioult, :init, :iprocess, :iestado, :inumoperultimp, :fprocesam, :qerror, 
	:qwarning, :busrdetail, :bnodesproceso, :banulada, :bimpresa, :qimpresiones, :mingresos, 
	:megresos, :mdebitos, :mcreditos, :qmovcnt, :qmovinv, :qmovord, :zlog, :zcomentar, 
	:idrvversion, :iimagen, :irelease, :sgrupousr, :itdformatoprinted, :fcreacionusr, 
	:inumoperv3, :iws, :fcreacion, :iwsult, :fultima, :iusuario, :iejecucion, :bmovmanual,
	:isucursal
	set_table_name "OPRMAEST"
	
end