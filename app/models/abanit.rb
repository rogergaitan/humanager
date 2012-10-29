# == Schema Information
#
# Table name: abanits
#
#  init                     :string(20)       not null, primary key
#  ntercero                 :string(80)
#  idigchequeo              :string(2)
#  bempresa                 :boolean          default(FALSE)
#  napellido                :string(30)
#  itddocum                 :integer
#  botrotercero             :boolean          default(FALSE)
#  itdotrotercero           :integer
#  bproveedor               :boolean          default(FALSE)
#  itdproveedor             :integer
#  bcliente                 :boolean          default(FALSE)
#  itdcliente               :integer
#  bvendedor                :boolean          default(FALSE)
#  itdvendedor              :integer
#  bempleado                :boolean          default(FALSE)
#  itdempleado              :integer
#  ncomercial               :string(80)
#  bncomercial              :boolean          default(FALSE)
#  isexo                    :string(1)
#  fnacimiento              :date
#  stratamiento             :string(15)
#  sprofesion               :string(15)
#  scargo                   :string(15)
#  swww                     :string(80)
#  semail                   :string(80)
#  smsn                     :string(80)
#  sskype                   :string(30)
#  zfoto                    :binary
#  bvisible                 :boolean          default(FALSE)
#  sclasiflegal             :string(30)
#  ipais                    :string(5)
#  idep                     :string(5)
#  imun                     :string(5)
#  tdireccion               :string(150)
#  sbarrio                  :string(20)
#  ttelefono                :string(30)
#  ttelefono2               :string(30)
#  ttelefono3               :string(30)
#  tcelular                 :string(30)
#  tfax                     :string(30)
#  itdcategoria             :string(20)
#  itdtercero               :string(20)
#  scodigoalterno           :string(20)
#  nzona                    :string(10)
#  clase1                   :string(20)
#  clase2                   :string(20)
#  dato1                    :string(20)
#  dato2                    :string(20)
#  qvalor1                  :decimal(12, 8)
#  qvalor2                  :decimal(12, 8)
#  sobservaciones           :text(8)
#  ivendedor                :string(20)
#  iactividadeconomica      :string(30)
#  itiponegocio             :string(30)
#  bperfil                  :boolean          default(FALSE)
#  iperfil                  :string(10)
#  ilistaprecios            :integer
#  icccliente               :string(20)
#  pdescuentoventasfijo     :float(4)
#  berrorexcesocupocredito  :boolean          default(FALSE)
#  qdiasplazocxc            :integer
#  bbloquearcreditos        :boolean          default(FALSE)
#  mcupocredito             :decimal(18, 4)
#  iccempleado              :string(20)
#  iautorizacionblqcreditos :string(20)
#  ictanombre               :string(20)
#  ictanumero               :string(20)
#  ictabanco                :string(20)
#  ictatipo                 :string(20)
#  ictaformapago            :string(20)
#  bbloquearpagos           :boolean          default(FALSE)
#  iautorizacionblqpagos    :string(20)
#  bmarcadian               :boolean          default(FALSE)
#  berrdian                 :boolean          default(FALSE)
#  calc_ipaisidep           :string(0)
#  calc_ipaisidepimun       :string(0)
#  iws                      :string(15)
#  fcreacion                :datetime
#  iwsult                   :string(15)
#  fultima                  :datetime
#  iusuario                 :string(15)
#  iusuarioult              :string(15)
#  qregdirecciones          :integer
#  qregcontactos            :integer
#  qregdatosvendedor        :integer
#  qreglineas               :integer
#  qregproductos            :integer
#  calc_nterceronapellido   :string(0)
#  calc_napellidontercero   :string(0)
#  qregnomcnt               :integer
#  qregentidades            :integer
#

# -*- encoding : utf-8 -*-
class Abanit < ActiveRecord::Base
	establish_connection :firebird
	attr_accessible :init, :ntercero
end
