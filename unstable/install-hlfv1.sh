ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.12.2
docker tag hyperledger/composer-playground:0.12.2 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��Y �=�r�r�=��fRNR�TN�Oر���&9CIQ>���U�DJ�H�d�x��q8��B�R�T>�T����<�;�y�/�E�$zw�~�HL�� ��L��b��̀��l�@G����C������@,&���xX�O!"��GbD�JQ!*	�G���G@����c����m®f��[��W
]dZ6����3�����dms �L���3�f�P3����m��?e�6l��f��L�d����D��v�i[.I �ٖ�%l�?�X2����62�!R�pxPɔ?���|n��= ���D�W��Z�6x;Y�?o#�Іe6â�#�!B���5�9&�u�n^��J��Ȧ�գJ&����X��0����SMhHwq碾��d0�6O��@�MD���uMG7�^�5SSu_E�bjJ�V�	Ȳʠ+�ElR�k�+.Bl��1�+66~���ȗ�PЗm2y*�E���v�6��� ,�æ�L��K�x����S��7̎�
y����;:�=؎Qa��S���P\���jX��V���Ӵ΁���E��bf8^����!�W`�������P>gԟ?tst��{�_}t�e��Ǧ�Rf�t���4Q��M)F>Yvn�����60]��7Qp�{�l1��:ttϐ��ԇfeҌ}�p��m�W�PQ7@�?�н�A��x<:������8��$1}���������o#�F��ՠռkl����_�����@X�H��±���
x�]�������SA��(*��j&]&�竤\��P98*�2o��l����A���O�:��� ��-��r���T��t~V��k�_���ˆ�߁J6P���ƽ�������bX�N�lm�Wt���r��5��!!E�B0�N�� ��LPae�1�#k�9�4��M�A�"w�Iq;-t�nǼv;�օ6e�6ĊLD�k66������lo�;����.�<i:5�s�<��1֭ ��y;Q:v��M)��˟�)ȰX�2њ&
��(z�D���h�Ϗ5<䲦c��4�T�[Xw�Z����0w�A������|�ѷF�Ps4]@Sij]��7����Ł�+�!Z@�{�[2��� ����H0"��@�Rs�A�?ws����$���Av�4�k���`��O��4{;tWp��&O'��� 
�z�_���@�<Pwv��&�AK�u �����"`:����K!��+Y6�<��8�P�y�\e":|��:xK��C�x��� ��_Q�Y
��Ā�#�Qڐ4{����?�ؐw���d���FO6�[�m�L;9l�&͚m��@��;������{Kfh�"$�sQؘ������医�1�Q��v	d�=��vu~�� ��<7�Ή�̲�TF��q����  ��$z����z��蓘�O(���pǊ�a�=rB��h6�DyW1�ط�d�\���u-,�#����4f������y΄|�`#�u�ޘ�1~����t�<o"�W�	��*m�)��ϯ��d��
���`�ի�T�>�;4��W`�<t��^9��©�@k����O���~(���'�k��
X��|�0C�GsyOm,�Q
ǧ�_\���\?)=:�q�3�l���OO�v��;fb�稷�3a�u�ӤȪA�l��t���	�	W��W>TR��au�g�6!�����yveog������e�9ˁK��f�d9��p�)W������9�@��cX�~I�t�i��X!�A#��d�/��C����$�V����G�Y�S��o�*����B��:��	�Y��Q��Bd�Tk�Z&j�Q��/4�γ?���/���<��w��[�tf�;OM޿���9�sY�E�C`8�2y����W�-"�K�dIG�t�V"dD�|�[��?-���"��1b3���l4��ya|w�����B|�����ߗ3�д�s�L�#�0���#����_��'���=1:m�dBtյ0�㄰Ϡg�׫Νa��O�Kwoc���?����:�s%�|���NRp���o������%(x����L�$[�������݅c���M��4��tLͰ���64T+��x u��G6}���N�'�D�\N����0�h����(���D�l������}��%=��O��e�6�AF�{֐�D��O�_�U��V,ԧJ��X��3a�FȔE���;M+P�AR6➘m0�������t�b�pO]�)��5��c��"�L�V&㯃��9���}�L�N��5>��EG�X�\�������e�?.M��D"��[��w_�A�|���
W�C��a�]K!��B���Z�����q���ӻ��� Ġ��+�V�
2�����ٽU�Q�jm��������%(`��G�ؔ�������~��jA���M�|&��0��S|�k��U�_��tS���K���i���u��J��� ������vg��~H��>�f@���=�w��`,��nvA�3�*�tf, �48�e�i�~�0��6���B��m�#�d��7��vы��K3�"ef^�+����`��&�l7����������1QG�_�Ʉ>K�oxY#f�՘J43]�D��2feØ�0� c��S�c�^�2��ic�'M�� e,��pD�(�YW��2��"��D��Yɼ[�Ռ��/(<�77����ڸ���K���U�������SоX�����h|��'���+����>p������?�������?Lٟ~B���HR8�UWDE��^�K�V"��a)�H���DDR���&b-�׶�э�������4�y�_���;]#�qD6��o����m�ѷO9.����7�y㟸����__m��I"���7_���<�{����������w���?�.���ߜ�d�jZ�xL���/�)#m0��q~��ߌ��=�.�^���{�6n��G��������sLޤ�%����K�u��������J��J����0�(�I���u�Р���'O��3�,巯xKk�s�<���}�"��5�c���ķ"�V}+��T�RR8��LĶT((IP������0%)'Mh>�+^AdY�S+@������E�ʔ��l>%W3���Q��S��TJVR��Oʍ|Y.:�q�E_%s}�&��LK/�R���>�_���S.3�������Q&�,����K��l�	�j�Ul�rz�y����E�\>r�)��1y�%s���uN���ix�"W�߸���%�g���M�Y{���*��ZX��M���)T3�b�ߞ���m*�BU����B5/T��Zv�ʄa�;��<Y+��^�t�>.�r�����L�@��.�,��Y��u�v�sZ͜�%����;�(�u���I��)��.3�BR`r�wR:)��$*��0
���rY[�]���b�VM���Lr���\� %�F&�Jy�{�]Y��ɜ��w�,���E�Z8���x�v�wr�ci2'���䮱�:9����)ܓ��P�hZ�?��uz�b%��
�a9v&e��Fo�ZM�d���VM�2�P�D�x���t�w˅�\����\HY�Wj�WjR{r>�6ϠO擉w�Y�o���;m�yxp`
�l���_Gw��;�=#3����\���d�b�T��V=E��LDO��q�"��GQ�89�'�)5��7*ѽn_�U�ř��{�Dܩ�3�v���SR"�U�Gey��D>SL�P~0C��O��h�kF�֘�����������}AcB�� ~&`���ۋ�=���'��������s�}+��%�������(F��+�1?鰜?&��eNY�c�����,/��ɜЃԇ*������'��Jh�Z�1wv �*�Nt��g�H�,��$.WJ��f7e����N�u������c����j<���Q�T���YE��w�9��j�G;Ճ0
CE����~z�*�6J���z����z�>���r��a����?������f�������2�x��_��\	�����~>5n���^�w������KJ�Ԑ30�33���f_.NN���F�#�9|�=�Z�8�7�q��hb,�㎸��ߺ��mȇ=q��zBb�c4�y��;;�|���=j����wlLK�Z#؇7���%������WO@
w�&���'��	Y�A��Y���\�A�	��<L�	�io�Yn]C�6�%x1p@��nҁٰx iT��EL�:�ꂆv��-Іl��'^�0��.��'Kc��ߓ�_┞����"��Q �qj�6��b���6��W:Ha�XA��tA��B��R�#����ce�ct�زݟ�d��y��K1�l{r�P��Tx���N�>��>�#���8Z��2��d�k�{u]�xͦ�p5&B42����>vL��k���U���EC�{�c,�)UD��襫�.��6�  M�i����e������>m��(K��a@L��z��dJ� x^F�l/6A�ɴ�~a��(/����J'=8F'E��l<?`K�7/�@��l�{4��?���<��"���'��MI����O��tgG�$�=1b���
;?�7W�~!/7m�^k 퓱�B�!���͘�}�I�KRs(��|	Ldu��u��>�h���ӳ_ǘ�imwR�>�Iɜ�_�+�3Np�q��&��ɵ���>�
��t�e�5�3��4�_>��2���[_�k�{�{ѓ�HU��M�-%��$_�!��f��z�#��:��%:�-�Wk!7P��Tޭ%Ѕ'���C�;�1~��^R.�Lq�Cf	�sVi�{���+b��]���}�#�u�W}��>i�.M��(�K�����o'T���f�k#�v�.�t`hR�c;t@Ȣ��E����~�F����G�[��Lִu�h��Ai��c�rM�e���B2�
m�����
�u��H��@�S�X�;m�n�>W��o��_0R���d>�����4��o.>�:Y,��C��Ơ:!�Զ�(��>kU�i�*x,��8bݝ��%��O��m �Xh+�~�da��������px������k�uK��=Msq7=Ej�A����F}��#��\���c'qn���dq��N��y�؉�,P�@H3�#�7�vĤ-`3!z�X�@����G��}W�֨sZ}�^����:����Ǐ���ԏ�<�G��/����䯩������?_��|���|����Ǒ�q�{8�@~����?z��G+�6�u]L�򧟅�P4$+&�Cr��(�b���c
ERX��p+F�
�q� �R4F�!��h>��_��/�<��G?��~�gs3�����;��|������W(Z=�7����.�m����=���=����ׄR>��_>��C�|[��߂<�.� �X�Ŕ��+��f����-K)��+�K�2��y������1K��Bn�r�U�]���]�+v������l�\�7Evg����ͳK�z���+�B�!Y�����R�<���6�.�ZE����C�9s�֫�qc[4ZW(��ߥ8�!�;�a��d�-";�}3a��ܜ��ߚg�p����dyZ'b�P4�d�an���K���8�F������c~y�^09s�E3��5H���c�_�._fǚ�)�ȥ�b��D��D";+���LI˔���Jٶ��Lt����B
ehk�;Ɂ@G!b,m͏@ד� �&k�̢��l� z���rVs|��IJ�vѹN�0��H�K���&��(L�
|m��ԇ�vw|��(�E��"�w�I��=��K\G0�y,���c5S�&ǝq8��-��<�L;q>Y�Ze��f�R�(��a���������)?VD)��hE/����-vy�Wr�]���]���]���]���]q��]a��]Q��]A��]1��]!��]��.��%�����YJ�D�-���x%��X�v�=���j"^�1�%Ne�L+Ƈ�m�C܋�YQ�\������.��T�֪��v�'j���{�yk�n�~W�Ժ�e���b2�����9n�ِ�FU���-�Y�Ū)�/7eB'�Z�V�L��T8Q���ɱ|m���9��d��Z� ������4Ft�8N����\v���]�r�[�x+"�����O�N�±�L�D�R�A��fNgʬ�֫��� CF:���8O�2z�j�T�P�dR�F97i�k�R��n��(5�.�2���]��v��^|8
�e����k������+��nx]��{o�z%�b�!���[pq�ɷ6������O�}-p������u�נNM�x��޸�#�/o���u�b�?� �>
|���}�}�
�����1���a�����JQ�YZ�L�V:�7�����L��.�\�X��vkK�K���	�.�:?Nl�}�L؂��L�<�\�m�f�R���Bnc5�%b����u�e��&0eW���[(0Q�"-2���,xf�8�1�R�R��,�D*2��T���D��Ĩ|�:;�c<�`|��:VX���v[4��>N�Ƽ��h����ʏӕ5��H�l)�:�e��J$�ZN���9�;��y�=��4�)T�CZ��NAe�����юJ����x�81���ܒ@�[O�F�*���K�YS��l�f�Vi��,��Z�����`P�1Q�E��Zβ :�D��_6[�e�t�fNcz�m�h�*ݰ�7f�L���h��:Y�n�2{��o]�4q`(7=C�PO�<_�i&�E39�3��[����Y`xW�g6�Ē��2;�v]��x\ńk�ȅ�����E��/���z���X�Y�q�ݑ������{t��e�%�ͪ6-$����r�-{����Dޘu$-����.N��[KJ6���j�<V��D�#L1��8h�pksu^���0��{}����R�<�8}�
Wh�6mC���@���,=&^0�ݩ�9��a��H�g�==�T��֞Nhu�)��N<��Tuɪ�X໴ MO[�h^I6*J:U�ey̥K�YaBm�H��K͋E�b�+���T�ݏ�T�����pa\)���i�1^ G�����F6�_]�Y(��J��٠0���T�cLF�J!a�*1��~��LҎ"�'\�QCn{#$M�L�����Y���*�ڎ�ʤ�yW� �=��
���
�J�4>>�)���<y�U\l�%�����t�JDg�B����X�F�J�,J2F�RZ�<�t�!m��T$��N�F��BA\��C�Dʙ�x:f
�å))xQ��Nz��
�qO!�-v�����7$��P��QKQ��d�9��\�����b�<= a� |T:�v��ZF%�,���T4M���Fa�58�k��hUc���˘ɳKC+��W߲l�G>����;~��+Dxv��˄V&�y6�/![����D����܌�~�Yp����..�J�A�-�M}���,���a$��-�K%�^��#�������?zy���󈶣����7�7��g�O��3�FE�T��!q/��&q�W
o�>F�$�����Ȫ�; �=�Lo�O����`%Cr
��'��N���Y��^vy�,-�E�=@!:�'��t���½Ƚ�����!�%������Aa���F���?�C����>����m��N��`�q=���$Ȫ���N�!�\/w:a4��������|���:L�UIzp,M��b@w�#7�8��� x#4����H?��=?}��Mڟ�ݯ�A��z �w�s��y�ڨ
}-CΏ.]/������{��̺^d�c�v�W��� 9�*ms��';����\@���[O��їE�%t����E?�9@H����aI:�Q ��FL�͢���,n ��	@���݅��Rߘf��76i�,��T�.��Y�K'� o��h����b�,0( �r�S!��S{��SÕ�e��
��U#���	g�Ɠ��;X⣠C?�����s���L��� 6�zkkݧ�]E�U�3u2�߽2k�}�9_m<D�� k���I+��Y�
+��
�OV���V(���c��:Csk�^#k��UfWu\�4�������Y��@�;d� ��,0�Lƅ�^t<ɭ� ��u�Rǒv,��N`�"�Z��J.'�/�^H���b����o"l�?�����;�4luGp�`C�~���
�߮�M�.~]����W5�$���C_��u�VO�����@t:�T��K�^o��΂;�� ��}�œЀ9���V�� >������
'?HJ����i..���Е����Ë0�t�-9����.��FX���AI�\ɚ(D�����mlK���w��8l��A�DW �J���2v1�3I���VI��K<����}�ݗlةӄ��b��m�W��$x����.<�:�v�@yB�c=�4%D8h�\�6P�R�	��z�g!'AB_�� ;�w�7����0@�r$����akE���3;���`:�ՀU�X��� ����P�Is�6���[���<O-��e�5��\�Ϸ�m�\���ȴ��~d�2Q%�����cOW"�i�j�i8
��wyh}��-�{/^x�����2�&���a)N[����j��wZ�Ht�P-��շV�Z��b�����'��Ό�>9��LF}��k���	6����0|�긲�}es"w��A>��Gƺmⶵ!�q"��sNbX�XI
��<�4r�8��nI`M��P*Љ 
��b��]W�a��h�w�ƺ�������ɧ8���;��ǻv�/k��c���������!n�l���d�،�I�"���o	�8d�O�O��ڲ��17lY	���\# �����Y'h���������U���:�&w,q�
W�ei���E>���x��3�h|�k]��	p8�t�\��)W�Y;A�R;DRMB��d$F(RBd��ڭ����H�$����r��l�()�*AIgz�d@��.�?V�0+��ǲJ��'��'���-����S0T3�ڣر ބ�u���ͪ�cR�"�f����XD�d�P�-L�I�DQ���TT	IM���B�LFcJ8��%)���4��?'���>�?��1�춁⛮����-	=��h�%p����vQ��q׾`g����]1/d�\��U'�,W�3g�\2�U��3YiN;g�K"��Y�ȕJ�0h]a����������_�u7{�'�\X�dPq:#��<��w<vUn�j�}�u�sP��֎�L�3�hl��8WC�I��Fwڄ���V�L�:����`�h�w�M��d�N�Z�۹a��t&`����Z�}@���/9L��䷢|^H��\�D��ɳ<�7���h>ϱ��6O�SN�g�g\������l:T�'(��{��L����б���~��%A�gE^zz���r��	��6����V�T�$�s��<�rb5W<��=s���iw��5ֱ$�3YO������a�YV���I�lI�E����"��%�Y�<e�K��s�x�e�19��FL%c��eP�o��G��'���;��ڒ�+�0��H �:vS{Dt�NSw��kh>x6��&�ݜ��ηl�1�-V�+X��������>�<j��9$��K�����rq�+$���"��e��Ō��f�<P(����f[ǻ��^�ɻY��0�E�_�����<�����2߉���#���ߒѷY��뿏�J��&�m������>���C�[�m��>���
��^ҫ �	۔�d$|���H�����ş�{��i_����8������������������Y�F镰�����^Ҿ�?E�I�.��`Q��ʸ%;�8&7�!���R+��-��b�v�"#�f$U����aBj��/�:���U���(|��;���K���a2o��l�ԡ�GZ��Α��>GSB���:ͅ�u]��+3Nr�*	T@ϩv�k�H�K�g�R���5�lq�?�F�j���"n��e}���O'�t�7�T�����WBXL��$u�Q��8��O�v~��U������K/_��ؐ��!�N�X�ۜ������U�����?t���H���`�{�_�t���������D���?@j��|��A�����<�}�s����^��� ��h�� �����?Im�� ���^-��~v@��/�K�_��Ԗ�'B����H�P��P��P�?��;�W���w�?���k�Nݶ�����-����pSA�����(
����&��;ڝT�teͧ��JJ��\s�5?��(5���e���k�Z�?u7��_j���Z�P�S���'�����߸���������������u*[ڹp��YT���kBr���������~^C��������'���<o?��*!��c{���Ode�=$v��J�v��z��.��f&;�>���4S�b�/[J�,�|��5��Nc�!���ҏ&�͏A{hӗo���{���O�G�>��>�2�v�|����]#N��	Ie��{��j�H����}��ݲ�˽0u�P�#'�����lz�SR�f�4-��!��$�m�v�c�����叩G[��~�S�4�dĘk�(3���iP����P��� 
@5���k�Z�?��+C��R��F-���O8��]
 �	� �	򟪭��?�_���ˢ�����_[�Ղ����
��Ԋ�����:��0�_ޜ��.������N�u̧{~N�j�р��7����_����_����Κ��e=�V0��)Ӑ�~R�8χb��[ool�k�Dp�j��#���\�f�FN�A	sL,8��l;czN����KQ�lo���kr�T�#��^��^~�	5����~)�F�$�_��ȭ���6�y��CCY�*�GT�c�㲻��M %�f�XiSf'脠7�
�FM>��։��Ùk��0b/WLt�QCɑu6S8��P\2�Fk}j���������?�_���[�l��(�+ ��_[�Ձ��W�/����:��l�a�?�����،b)�d)��8/@�c=��Y�'h¥'<%|ڧ��� �3~u��G��P���_���=G]�"!4[M�F�$c���;�k�kǼ�li�m�ŗ��eg��HGO^F��ɪ}�&�md��9���40��&Y�7��e;F
�P�$����9Hf^����?l�'ŝu �������?�C���}]�JQ��?�ա��?�����{����U�_u����ï���![Un7�	M���4�r����d�t��O�A�n���#�<�A3b\���].ջm�(�d���/�'�DW!:3B?&�=2�8:�C�2���306dUɦ�9��E=��8�������������u������ �_���_����j�ЀU���a�����+o�?��运���?�}[��ఞ0���ɑ|����ϖ��������3䢶?s ���O���Y�><�"U��(���C��\x� �8�rh�|���'�Z$|����4ZMA��J��Y��4l���7B}8�1ꄗg�һ�'��S�9�f얜�߬����H���8|y
ל���+^� 0얐k¥�	��.���80���|���@oG��X��u�X#�²��O��L'm5���y�0��[!v&J��R�""L�������dCT䑊��C�j��C����t�v�(��%��Az�ݎ�4[�{|$,��I�:����u�u��~���<<	:��WVW���z/�A�a��G��+���]��/ʸ�o�������`��ԁ�q�A���KA)��~�EY�����O�P�> ���!������`��"���0��h��<%Y���3Hu9�ui��ei6 \ov=�%p|�r��K�,v~�P�?��E��S
~������BImj�^8�P���F�x���\��YкF&����Cɛ��<8�fA.�d�������F>D6kB��:�M�(./��z|�(o����szx�h��s��N�H�e��(�n���{Q��?F>8���R����x��Y�e\���4���_j������%��wg�2��������r�a��"��������vpMP��h�;A��W����}����~�oFz�<k
�s2a�D^�����_T2�-��m�[���3���ǐ�����������1��1�?�T���w���'��ګ�ii��wd�I4U�KjOKd<��Bg�[�GL<��SW�Ֆ;3����q�\bu�Q2m6�)��a�.-K�i<�F��\�9��zm;��qna�s�#(�솽U�����|���w�آ��R�u�S�!�ɶ�"����r���i@�n�Qc���8FR��܌�|��Y3TB�R�d�wϳ��ȩ++��1�����E��Hr�q��C��c٥������ߊP������
�����������\��A�����o����R ��0���0�������q@-����u���W�����Kp�Z���	��2 ��������[m����7
��|����]h���e\����$��������}�O ��������?���?����W����!*�?����=�� �_
j��Q!����+����/0�Q
���Q6���� !��@��?@�ÿz��P�����0�Qj��`3�B@����_-����� �/	5�X� u���?���P
 �� ������"�������j��������(����?���P
 �� ������?�,5�Y��U���k�Z���{��翗�Z�?����:��0�_`���a��_]��j�����Wj��V�9�'� ��
 ����u���{�(u���Aڛ�>�(;g�`��s$N��ٙ����.�2.�a��r.IR����z����4�E�S�?*�K�U����v�Rq��T�
m4w�ހa�(�佞�&Q��V�8}~���$���8>�-)���jl��b��"�wG13l}�j��h�"�(F�Z����9Z�gcH��VP�����P\�7v��>��7%�p�Iց�-M�^��=��_��������1t}+E��P�U�Z�?��T�������RV�b|Aԁ���������F�����5E���<;����/���N�3���������<��^4�~��w��2��d�'�����	;��mӞo7l�izj���V�}O�A��r����`!S:��E=��w翃�[jp���?������P��/������_���_�������Xj��.�G�?���[����������n2"ı��7��ȖGV��7���W�gmw�v��NK��c��'�H{�n�Z~�!Wܖ&��4�B����L��H�d3h�G���4:�ȱ�CuI/���s�9���9�tJ�o�z�����v��啾f�=]:�:�o�-!ׄ�{a'�rK����%�!o.�q��4�p���H�<+��n �PaYD��	��餭f��>�Ɇ�t��go9I[�q̛L<"bg��mG���;9s�p����Q�HP���m���(�,\��ƌ��$L;��Ī9ߤ�5����
�$�'�Y�{}x�;~���28�K�g\��|���'.��_�P�a��O��.���Jt��ڢ�����O��_���8���I��2P�?�zB�G�P��c����#Q�������(����M?��t3����qBo�p	���{ү��hI�y������$o?;n��G�z�1��s?�v�d�!=��f�!�=?#�×�o�m]��ެ��պ�:����ϱ%c����qZ��	B~�3�°G�*����́�(5�en'��U*�?���1L%��a���9՛���a:�v2Z���`�a��.��|b���-�d�=�o���΍/�5©|�������C��ٺ<dt������I�	��ؽ��%����`�l�a���Tc�'_�!+��:�+�9�;�$�|$��^d��]��N���Ƽc�	w��5B�8`���P��+��i�ܵ�k}���M��ϖ��c��Kq_�}}�j�����?����r��Q�Gc��1s#q��>�^&i���$���|�3$��]��h�����07@}l�ݟ�:���������W��Kt8�;���"/�PDvf���l��!�<z@)��p��e��^��Y� �+W�����g�����?F��W��0�������>����e\�7�?�~���W
���z���s��ʞ=��,�����pB������Z��~�z��s����l�Ǽ�շq?�g���������h�}���7��f�!���"ڛC(�V�9�"�mH� h-�����θ5��ר�M;�h��H]�4/�����v�?9$���q1Y��a������C>���l?���zr���F�=o7�Q�a�n;��Jx:KӖ�,Ƽ2]��<���h�W�I�ì��^�0�
&���/%J�R^���+;���S5��hfHs��6�����s���ʲK6}E����0������P��?�����RP���ri���e1���8~�����+�	���Q.�.�^�ƿ��Q��c����0�>e\������?��ǯ��Zz���@kQn�4��'O�Xm��a�C���˼q�E���/[����l������5���C�����:迋ڻ�(�2P��߽���	���?����_աd����vPmP��c������R�V�G��?x��4�ݦ��kC;�z2��g�a1��Hy���	�-������V��n�>Jk}qQ@�5�r"Y2�Iӳ��Ϻ�:�qryLy~L��X>Zʽ[�
�h��ֹB���\�ӗ��&ۭ�7����sR�����ܜԩs���Cz��V*�����[9��� uj��mw҉Τ3�f3q}���D��w���Zk���Jxa/�<���i9�Bg\�D{[[w:�T��hV�n�l=����}s|��*&��h�6�2�rڶ�t��H�1k	\�m����J	/Sh
�y���y�G�)q�<��n�x�=���gw;�b�ꇽ��v~��6lIi6F�í2�%Ym^���'�u����vcR��ld���j0��U���UL,ZJ�Ѷ�f�~���#ؕS�벵��R��p�qT��J%)�H]�+����|ß&�um�o��Ʉ,�C�?�����_��BG�����#��e�'_���L��O����O������ު���!�\��m�y���GG����rF.����o����&@�7���ߠ����-����_���-������gH���!��_�������_��C��@�A������_��T�����v ������E����(��B�����3W��@�� '�u!���_����� �����]ra��W�!�#P�����o��˅�/�?@�GF�A�!#���/�?$��2�?@��� �`�쿬�?����o��˅���?2r��P���/�?$���� ������h�������L@i�����������\�?s���eB>���Q�����������K.�?���D���V�1������߶���/R�?�������)�$�?g5���<7׭2m2��ͭb�5M�dR�����d˘d��ɱ÷�uz��E������lx��wz�(q��Fu����u��
M�)�ǭ�o2��wY��^�պ(����t�6ǝ6&w�Ɋ~HS,��8�m��/k��Ȏ�d�)-zB:]=h�V�E�Gu:,�q;,����m����d�U��\OS���՛�nǮU#�rEy�'����$YG���Wd�W�����E�n𜑇���U��a�7���y���AJ�?�}��n��%��:~��'jv��w�^���b�Q�ˆ��m��m��E��Ξ����Fu�j�[��j���#��͆�6,E�D8��~],���ߪb۰�sUk��ɫ�v��]mN���&�P;z��%�����7�{#��/D.� ����_���_0���������.��������_����n�QP�C��zVa��U���?��W��p���)VĚ8�)__�_ف����6��h�@*���z�.K�l�?���E��5}4o����D�0.L�x\��!iͱS��ˉI�U'�N��z�����~Q�j�J)l�[m,���m
��:;���_e�*��і����D�Z�F�1M!��bwXO����h�IJ�}v~s��V�~������^�|Jb���*P���r��KQ]٨5�V���v9X��ͦ2⇃8?LKQUZ�X�8���N�Y2D{�����qqېI�]?hB����|/Ƀ�G�P�	o��?� �9%���[�����Y������Y���?�xY������������Y������&��n�����SW�`�'����E�Q��-���\��+���	y���=Y����L�?��x{��#�����K.�?���/������ ���m���X���X�	������_
�?2���4�C����D�}{:bG[U�7��q������0�Z�)�#fs?��
����s?���L�G����"�w��Ϲ�������uy�ݢ��]�D�����8�P�;fm���\����j�7��O�gCvfNcap���M#��8:�!,Y��dSSmG��Q����Ѽ��_�Jޯ�WOG���\�F��4��
�}8V�����tu���_����Ug"��`1�lF90'<���%ik��Nt��jX#9jSo�}2�V,�X���`�fa�w��ReCi��DpT���vra���?2��/G�����m��B�a�y��Ǘ0
�)�������`�?������_P������"���G�7	���m��B�Y�9��+{� �[������-��RI��_�T�c�Q_D��q��Hmك�d�S����>�ǲ�<<�����،��i
���=��)������0��ыFI�h���z~��T�i��,u��7CS��W�*G}���hA�F�P/rq{+��eY!F�o� `i�����$�����B�{�X�/t)E�W��|aʜ�b�-?
�¢��nkO�����lX޴��P�G&��^S:K�X�!m�WЭ	�m�������?L.�?���/P�+���G��	���m��A��ԕ��E��,ȏ�3e�7�"oY�fh�f΋�N[,�s�N��E�d�l��a�OZk�:ϙ�O�9�c�V���L�������?r��?�������O�H&O��Q�Q�Nf��j�j�4*���<�ބ&{�`��Vb�埈`g��kL^�J���������ʝJ]X��5rr�4׉Y<�ZV p�|��n4��?_K���������q�������\�?�� ��?-������&Ƀ����������z�X�􎬊Ĝ�*Ċ��K���[Q�Ew��/�N��>�\_:���`K��_a;�YRL=4�,�G�~u�N�����[�iW||Ռڲn0.O������&^����24��%��E��3��g����``��"���_���_���?`���y��X��"�e��S�ϖ>�����ct�\���t/B�����S�����X �������wں�E[M�$������q��tc����r�J̧2�"��rV�#��'�`�)��Byh�X��a���שҬ�ڶ��RW�/�<,��DM���';O|�V�OE�;�q:&�BwX��u� v-a��$:9�6�RIv��������my�(�+�*"c���=QJ��S�M��MԵ�_�S��i�򳽈}U8P��Hԫ+��u��ˆď䓻p��J��ڞ[���b�n�0Fb��*4��Â�S�}�1�Յި���|8ezTqZ&�r�w��#O�9��}tx]���'����B�i&��?�ݹm�x������:��_v��Gm�(�����	bO�>J5�cG�?��+�y����<�Y���t�Ϧ��|L������]$�=c��������{=���G�����CI�������5�L�X���R��7?�%�����?}J����p�}���?�㾊��i>�����������.0�ox��D����n���Ǎpm�N������{,4#���'縉�i$����I_�zR��v��I�d���r��x�0qcfr��${{��(����7�x�#����w��~�c�=�I��%���w�����w܏�ɫ���[~I��OO;v������<Q�T ���;�r��}u��������<��XK����~��`m�m3�Ϗy��ӕ�渆�޳�M��"�`纎k��DނO��?q'w&�� �Bo�q�4����ÿ�Z�~����f�?�i,<��/���צ�������{��$�|��9��f@�{�M�t����?n�q��W��œ,���67aF���x�s�pM�ӓU=���SJZ��E�qwɍ'�{Տ�j�����H�VM�;���Hva*�����t�w�j�ez�w�ח������=q�}                           p���4�� � 