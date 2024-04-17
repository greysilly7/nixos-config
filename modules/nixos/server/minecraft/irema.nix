{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  options.module.server.iremia.enable = lib.mkEnableOption "Enable Iremia MC Server";

  config = lib.mkIf config.module.server.iremia.enable {
    services.minecraft-servers.servers.iremia = {
      enable = true;
      enableReload = true;
      package = pkgs.inputs.nix-minecraft.fabricServers.fabric-1_20_4;
      jvmOpts = "-Xms2G -Xmx4G";
      serverProperties = {
        server-port = 25565;
      };
      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            AntiXray = fetchurl {
              url = "https://cdn.modrinth.com/data/sml2FMaA/versions/R561af8w/anti-xray-1.3.3-Fabric-1.20.4.jar";
              sha512 = "73636aee07292598d2108d7b9cf6e72c36f413fd88a69b907aa88ef47c36c09d8d2e374271e18c07a7e43ac8ee5e11e61ba7beeaef1f17a5cc0aec43d86a4ce6";
            };
            Archiectry = fetchurl {
              url = "https://cdn.modrinth.com/data/lhGA9TYQ/versions/kVjQWX0l/architectury-11.1.17-fabric.jar";
              sha512 = "294112b2db8b5cef2051fede57dfacfb00cc7fce737cbf7db3c2de8b81f0cd17bd29a3e2849c3e05bd9e801fbfa3d14e5a83b6531b3d37e5d7c650cff4714362";
            };
            ArmorStandEditor = fetchurl {
              url = "https://cdn.modrinth.com/data/Ef9ZREBZ/versions/GwsOPBYy/armor-stand-editor-2.3.0%2B1.20.3-rc1.jar";
              sha512 = "ad7990689999509f0f0314f6c9bb72ba0be6823f38be9f63e1de145383c722cae2d017a7b5818231596caeb107ba70d8776c2d311123f164fbdccbf2c3b73ef8";
            };
            AudioPlayer = fetchurl {
              url = "https://cdn.modrinth.com/data/SRlzjEBS/versions/34d1C0gI/audioplayer-fabric-1.20.4-1.9.1.jar";
              sha512 = "80a7f5ea88a7aaee4068f9e0bd06a62671d67a80c5e6faf5d0410017390f5e1f5dee8d8993583795cfdf1bb271635bc0f5dfcfb94d80f244b412770aaedcbc10";
            };
            BlueMap = fetchurl {
              url = "https://cdn.modrinth.com/data/swbUV1cr/versions/QjdzVjGq/BlueMap-3.20-fabric-1.20.jar";
              sha512 = "615df930ca1c0c658338cde7ff69c4ece1ecd6a1e5db37201e55eda5cbec70abc128d856f2683d8b695d92ffeb15e9bc54eb373a896f89381f6561faac8d52ef";
            };
            C2ME = fetchurl {
              url = "https://cdn.modrinth.com/data/VSNURh3q/versions/9Cu1rJ2H/c2me-fabric-mc1.20.4-0.2.0%2Balpha.11.65.jar";
              sha512 = "263b06d54a1fc01c8050ea00c559b67e8b1060d812809d2c0c5731470ba97c26b27c72f0be864f0677f71417d94514547de053ae69d3fffed150942e045f9075";
            };
            Carpet = fetchurl {
              url = "https://cdn.modrinth.com/data/TQTTVgYE/versions/yYzR60Xd/fabric-carpet-1.20.3-1.4.128%2Bv231205.jar";
              sha512 = "6ca0bd328a76b7c3c10eb0253cb57eba8791087775467fbe2217c7f938c0064700bdca4cbf358e7f2f3427ae50a6d63f520f2b1a549cb36da1cc718812f86375";
            };
            CarpetExtra = fetchurl {
              url = "https://cdn.modrinth.com/data/VX3TgwQh/versions/APnGg1O6/carpet-extra-1.20.3-1.4.128.jar";
              sha512 = "68c14e3661faeb81d13129193372fbd9e3c1b3a0ff496a5fe93404c96d791d4c5cec53d030ad63d8e1112db4660ea65f5ffb1f7fb1c76f7935fcb800a34d10c3";
            };
            Chunky = fetchurl {
              url = "https://cdn.modrinth.com/data/fALzjamp/versions/iwsbfPGg/Chunky-1.3.138.jar";
              sha512 = "872c9b60381ec9ee7ebd78f31977220cf23a5fda6b9d902e36480024352640993146a389a0052e371ff31b52e80ae4bcf6da27f6af011a88fd1f0b3bd8d6a668";
            };
            ChunkyExtended = fetchurl {
              url = "https://cdn.modrinth.com/data/LFJf0Klb/versions/FyCBGvsX/chunky_extended-2.1.1.jar";
              sha512 = "346a1a781697f77776873d3b6342a9e0abbaefd1f583066c52e2f208ff156c99b2fdc63bdcd65b3b75ae2e1dad28c3053a9b32643695ce587a219180ec1349ab";
            };
            ClothConfig = fetchurl {
              url = "https://cdn.modrinth.com/data/9s6osm5g/versions/eBZiZ9NS/cloth-config-13.0.121-fabric.jar";
              sha512 = "05a389ce4383c7b202e6aa7b37f39da01b6ee1f5b22dad076d528891b5ef8bcae335b2d7930b33b753ad34f1a61bae52f3447f74a4df6739239344674b59b0c5";
            };
            Collective = fetchurl {
              url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/n9TNesVV/collective-1.20.4-7.40.jar";
              sha512 = "12002b050153f2d1a4e36e77e751b1a2f9f5c134222b6e81f491760c921b12beb3a582735b20f96d2ef54a1289a159ac5ac83a595f219cbf6133d69e6d7bd0c1";
            };
            ConnectedDoors = fetchurl {
              url = "https://cdn.modrinth.com/data/3KwAcCSv/versions/tnuNyIy1/connected-doors-1.2%2B1.20.jar";
              sha512 = "e53d38384de0925febd564fae4ed0b867319a207ec6c634a15bb82c09ca295ab6f508825432772e27de08c7ccbceb0738a998a7585134f3d9f4818f85aa79279";
            };
            ConvientModGriefing = fetchurl {
              url = "https://cdn.modrinth.com/data/FJI3H6YI/versions/S8Mdyp5k/convenient-mobgriefing-2.1.1.jar";
              sha512 = "7eb57c861506bc35057d389a5317362090675efb067bf8b19c4a4c69fce8e6b23116e644df2a2b293a3f1bab751aa1b34c23c1f8bf71985eb759ed8e959a17b2";
            };
            Discord4Fabric = fetchurl {
              url = "https://cdn.modrinth.com/data/qc4oLwfr/versions/3oA02nXA/discord4fabric-1.20.4-1.11.1.jar";
              sha512 = "e37f7c977b09a306ee0ec52e1fc38d15926bbce998a43de6cce0e4be9a75affbe816ed6524386a4c264b67bf8fcc68b03f670190ec9b5aac1d5587ddd1021bfb";
            };
            DragonsDropElytras = fetchurl {
              url = "https://cdn.modrinth.com/data/DPkbo3dg/versions/K4nTfvLF/dragondropselytra-1.20.4-3.3.jar";
              sha512 = "6ad0445b892d82ed8540f8706c7dba792f9a04c66d857ae101ce33acd2dcbacdae1d346c23c680c5d5bfd1101cdf70fd2cd25119dd8c2edd1b3073a85b3f5da0";
            };

            FabricAPI = fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/xklQBMta/fabric-api-0.97.0%2B1.20.4.jar";
              sha512 = "1b4230e5bbc7dad540170cac1cee2b6d372cfa08beea9ddfaef90665295ce2c4d6d77f88688b7934bb91529d2fccab1ab7022652d7b52944b57175fbe133ab50";
            };

            FabricLanguageKoltin = fetchurl {
              url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/ZMokinzs/fabric-language-kotlin-1.10.19%2Bkotlin.1.9.23.jar";
              sha512 = "0c31443b5061d85787de452d1dc0196a0e3391146aa5f030ef5fa95558b0f2b2bb9a0613fc0e5621e9d796d06e717fef0d0c98046f4ead04d150e0eb2d19abdc";
            };

            FabricTailor = fetchurl {
              url = "https://cdn.modrinth.com/data/g8w1NapE/versions/UWCp2YMj/fabrictailor-2.3.1.jar";
              sha512 = "450be0ea6db5dede57c2a554db10a584dd9b3b2f30c0650921f3043a74ca0a6414b2f71fef5515b2c62fdfa75c70f74b1cc2f8d42c4cb9ed1c78ff38a6132a1c";
            };

            FallingTree = fetchurl {
              url = "https://cdn.modrinth.com/data/Fb4jn8m6/versions/mb15RrXi/FallingTree-1.20.4-1.20.4.3.jar";
              sha512 = "ac55e89111aaeabe4b7919e962bf3c31fb3632ab23a4fc18206f441228fc4ccdc1d95716c8fee46cd4d6c3f915515ef44271ea05dcb9509e6ed4c0525f79267e";
            };

            FerriteCore = fetchurl {
              url = "https://cdn.modrinth.com/data/uXXizFIs/versions/pguEMpy9/ferritecore-6.0.3-fabric.jar";
              sha512 = "709ab6362dd1dcc432edd1e6c33aafba6f2d12be701bc14911107340f8ac2466779c4e57d8a303f0350c46478f23008e6eeca78e4eadedd0bdee63d4ae72ed9a";
            };

            FSit = fetchurl {
              url = "https://cdn.modrinth.com/data/J5NAzRqK/versions/6VXk2Epo/fsit-v2.1.0%2B1.20.2.jar";
              sha512 = "a198c6f1364b56c1d090bbd9dd3085bb32c1375cba015859750077b20cef3d6578a7181684d3205a846eda4e8204372b285e6969375c1b8c9c248f814fb4e9b8";
            };

            Graves = fetchurl {
              url = "https://cdn.modrinth.com/data/yn9u3ypm/versions/apUC1ksK/graves-3.2.2%2B1.20.4.jar";
              sha512 = "6f7fecc5815c8aa42bffe646a73de324a1f95729a2a91601a24a2c5fc2ed8f3c0e05d22fe82d27025a67c0a44ddfe13147cf645c89b6c3ed204990e1877ba69f";
            };

            HorseBuff = fetchurl {
              url = "https://cdn.modrinth.com/data/IrrG0G8l/versions/DVQXA6Vl/HorseBuff-1.20.2-2.1.3.jar";
              sha512 = "4b84c5c16c37570f8aaecc56e4bea11968fb0ba31f524030dccd81942be9967fbb0d04a3de74fec7e90dfaac078e8ad86d536666e4ee2e81c594379acc7126eb";
            };

            HyperLeash = fetchurl {
              url = "https://cdn.modrinth.com/data/KqZcJkQm/versions/igkJA2jN/hyperleash-1.1.jar";
              sha512 = "fe3e3668a3e329075b968f29db460e327da0e5af6c0ed5ad095dac06e70115899f5b6b657bdc25694c4ab11ce3c3ed516b525a164c510630739beb5c5eaf87e2";
            };

            Image2Map = fetchurl {
              url = "https://cdn.modrinth.com/data/13RpG7dA/versions/T71Apams/image2map-0.4.2%2B1.20.jar";
              sha512 = "37f20881f0f0a7f1233b6c5695d75d8bd7dfed185f00ec55a63df2c49594476dd3ab534abc06a66e4f4bd79f339c6778af3a804672bd153126484fc13abdfdc5";
            };

            ImprovedSigns = fetchurl {
              url = "https://cdn.modrinth.com/data/tEcCNQe7/versions/f0jwej2l/improvedsigns-1.3.3.jar";
              sha512 = "93d88adfeb4b092277a065865ccd4bd91dfc456efbde74e01e929751ade89d076984744b6d45f0953b6ed586f90516a136d06b07f1671d763b9fd29c043edc44";
            };

            InvViewer = fetchurl {
              url = "https://cdn.modrinth.com/data/jrDKjZP7/versions/nVacs1Yr/InvView-1.4.14-1.20.4%2B.jar";
              sha512 = "8313bf4c1b34d2d62547f1e0e478cbf44244278d0d22ed1f6861507d2a780faef72ce5a3762330830f39336cac3794f9be43031e6d9b84e10bb73f1037cf4adf";
            };

            JustPlayerHeads = fetchurl {
              url = "https://cdn.modrinth.com/data/YdVBZMNR/versions/1PTrLEdi/justplayerheads-1.20.4-3.6.jar";
              sha512 = "18f60f8075fcceb1e7470867ebbcf467da3ece5547ac82c7ddf809ed36af6cd9c3e8c7cc9a12acb2e5f19ad962b684cc371fa23bd4de8db5b7c0a94df0f6c096";
            };

            Krypton = fetchurl {
              url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/bRcuOnao/krypton-0.2.6.jar";
              sha512 = "a3e4eadcd8074a0a68a1378c90824b58199bedbab2f7eaa3961db9b10b99215805dde4eb73be5ec3118f38fbb0beaa8a1b6f9de6966a741d32dbf181a44ae11b";
            };

            Ledger = fetchurl {
              url = "https://cdn.modrinth.com/data/LVN9ygNV/versions/aeyvUBDY/ledger-1.2.10.jar";
              sha512 = "81bdf38b17da1620a37f17f2a2be8dc4200fa9dd400216d69e970cb59b17c3305bd95bcb6c13b75ac001c07d022dfa101d25a7843d81cafc769bdc6901d583d9";
            };

            Lithium = fetchurl {
              url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/nMhjKWVE/lithium-fabric-mc1.20.4-0.12.1.jar";
              sha512 = "70bea154eaafb2e4b5cb755cdb12c55d50f9296ab4c2855399da548f72d6d24c0a9f77e3da2b2ea5f47fa91d1258df4d08c6c6f24a25da887ed71cea93502508";
            };

            Luckperms = fetchurl {
              url = "https://cdn.modrinth.com/data/Vebnzrzj/versions/42RCP8I8/LuckPerms-Fabric-5.4.113.jar";
              sha512 = "08a99ca6c7bf0e99d75db5cf085c0cb0bd5146b1b99ab0aef400bae6c7074a1aedf70edb2f7b1a1a065d8d689c1f58d7e100a11ba81022ea66d65e4f84dea250";
            };

            MiniMOTD = fetchurl {
              url = "https://cdn.modrinth.com/data/16vhQOQN/versions/M7WdzIda/minimotd-fabric-mc1.20.4-2.1.0.jar";
              sha512 = "5cefc23cc391cea9b592a3847ac4d1eecf6d9dee55f952bb6e7b35b1d5a3a1b763378d802eaf0cd32842f4af6a91f1d33336fd816807bb07002ef8929702e0c2";
            };

            NoChatReports = fetchurl {
              url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/tfv6A4l5/NoChatReports-FABRIC-1.20.4-v2.5.0.jar";
              sha512 = "123501578045a30e7730530deeedebd7aae611c10d69359ba6d90aa53651455e8d08e86c4ef84242b18147eaa54775b4d06e57c1eae43a9f357bceb15a65a5ed";
            };

            Polymer = fetchurl {
              url = "https://cdn.modrinth.com/data/xGdtZczs/versions/Kk7rWLSf/polymer-bundled-0.7.7%2B1.20.4.jar";
              sha512 = "b5f9f9d0691a176fef9fb120bd883536cf5ca692b2f2687d934d40f50bbe3b58640d1d40f325df0a066a2abd813d4d90b46b743b1fbd6b65c694db96b1c1f50d";
            };

            RealisticSleep = fetchurl {
              url = "https://cdn.modrinth.com/data/ZPywkPEo/versions/vCoqEfJD/realisticsleep-1.10.2%2Bmc1.20.3-1.20.4.jar";
              sha512 = "e2903fcae00545a7100c99d9d09e02a9dc2c37294cf9e9f0c0271f63b43e1c2d5569104fab2af8eb45d91d14f7c6c02254a2c21a5fe7413d5d6a821f511387d5";
            };

            ScaffoldingDropsNearby = fetchurl {
              url = "https://cdn.modrinth.com/data/uO522mgw/versions/BKRP4oCQ/scaffoldingdropsnearby-1.20.4-3.2.jar";
              sha512 = "383e3270a0eb8dc13a22496576e86a09c8008d4d21dc2d21af63f10016196dfa85bfacb79a83b6f748cc69e5297fb4d0c378057874d178110a01b789f1d84d16";
            };

            SkeletonHorseSpawn = fetchurl {
              url = "https://cdn.modrinth.com/data/ZcqNoW8j/versions/u9r2871I/skeletonhorsespawn-1.20.4-3.8.jar";
              sha512 = "8373067ce04cf62aceda32b6ae728cb985918f39d826fe28b4d3c695ffd80146cc954cf505d9457c35c3854230a2ae6825a2af9e48f9bbf3c4ac53e9936601af";
            };

            Slumber = fetchurl {
              url = "https://cdn.modrinth.com/data/ksm6XRZ9/versions/mPf1P26X/slumber-1.2.0.jar";
              sha512 = "b7db00573440d64a8275f1a63a492eba00bb2575c460e05ea27e7bf63cfc2591a4b3dc913805c26fdbea1f959ff247d3532b433afef09a5fb4317ed2ce1dce14";
            };

            Spark = fetchurl {
              url = "https://cdn.modrinth.com/data/l6YH9Als/versions/FeV5OquF/spark-1.10.58-fabric.jar";
              sha512 = "dfc0ba346fea064848ceb3539dd05351327489c6cec09413c4b5ba8a25eefce44da89224cd9e778b7984fa789fbe00a9269e8994e2eec81b79e411f20579fd3c";
            };

            StyledChat = fetchurl {
              url = "https://cdn.modrinth.com/data/doqSKB0e/versions/hPPTz9OM/styled-chat-2.4.0%2B1.20.3.jar";
              sha512 = "8d4b8ab1ee925d2565df01716f7be50da1058c88997230125a79b8a59ba89aacfc5d58258a56a2f597989ed9d14d843b7d6b59afe366e103044a921ff0fbd1b6";
            };

            StyledNicknames = fetchurl {
              url = "https://cdn.modrinth.com/data/DOk6Gcdi/versions/R7dIzguo/styled-nicknames-1.4.0%2B1.20.3.jar";
              sha512 = "c607fe30ab4c293c0e4f06cac127c7b87e5b869c8e8219346dacba6dd90f20245c1c708d830e2f9f385b68f951dcee3e4e00d1b637828d8d85b0afe61ba3ebdd";
            };

            StyledPlayerList = fetchurl {
              url = "https://cdn.modrinth.com/data/DQIfKUHf/versions/jcLxMRaH/styledplayerlist-3.3.0%2B1.20.3.jar";
              sha512 = "6388425eba5defb843efcd9a7d278b1b1f30bb9801c15d5bcbf00496583d5f702e3a4d21a12332e188f310a84a22ad84549cecee48a32df8037428da0af5467e";
            };

            SuggestionTweaker = fetchurl {
              url = "https://cdn.modrinth.com/data/MBLj38R0/versions/RJeuHy76/suggestion-tweaker-1.20-1.5.1-fabric.jar";
              sha512 = "a4dd3c9842322a4d5ade9e38069e978a91f1f4ab4fa13e1243c44760ada28ac8fd0b34e409a66c3c49d0a6ee6a1073eb40ecf293bb79ea6b815d13a4e78db806";
            };

            TntBreaksBedrock = fetchurl {
              url = "https://cdn.modrinth.com/data/eU2O6Xp1/versions/OtrytWIm/tntbreaksbedrock-1.20.4-3.2.jar";
              sha512 = "048e0c9517627cd90c40954c2a3aeb729a4b62bbb679fced4ce3944624985511d2e5f3d699ec7c5c5f9578e72294dc7b6fcad7af1533e70af39d7a1e003fcef5";
            };

            VanillaPermissions = fetchurl {
              url = "https://cdn.modrinth.com/data/fdZkP5Bb/versions/I9QawL7F/vanilla-permissions-0.2.3%2B1.20.4.jar";
              sha512 = "67e68c0b421247a1c9e2a12937a06b60908ff4f7108166d568b488288578069a1cd922edc4d8893041cac395e39b6c9e09e7338cf2145e1c7f118cb513fd690c";
            };

            Vanish = fetchurl {
              url = "https://cdn.modrinth.com/data/UL4bJFDY/versions/DkEyt0Wk/vanish-1.5.2%2B1.20.4.jar";
              sha512 = "af9f3d71789e9281cced655a32cdc7db9d977b78a1870696c8b4df1b9bfbbe10515cdf6a0849ce4d5db5f7f53b8b37a79e0d0e119449703e27c01986ac771098";
            };

            VeryManyPlayers = fetchurl {
              url = "https://cdn.modrinth.com/data/wnEe9KBa/versions/I8LNJvF3/vmp-fabric-mc1.20.4-0.2.0%2Bbeta.7.139-all.jar";
              sha512 = "527056a673a2d9d0bc39a197f998497bf17ff304cccc8472fd215cc7a816a48fb88ce252dc185bdcbd162d099c5cbf59291b5bcbeb318f71f578bfb2c77513a6";
            };

            VoiceChat = fetchurl {
              url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/B23zGLmw/voicechat-fabric-1.20.4-2.5.12.jar";
              sha512 = "866a86a2e0625ca57d9022d9ae011cacd04391b37803aa41e606fbdbac04b02c4753b7e5e2218064c69d95c74c679fed0bbf0c7a25a17212ce5b4174a44ec7b8";
            };

            YAWP = fetchurl {
              url = "https://cdn.modrinth.com/data/py6EMmAJ/versions/bg7gh7bA/yawp-1.20.4-0.0.2.9-beta3-fabric.jar";
              sha512 = "2257fe6a510436dc82da6ac462b14b2a96cf4527aae29f62ff78324865deb3bf1066e560bb2fce4054401fe66407b40867193c93dc59f4ac3baaa1ce2e3a7fdc";
            };

            ZombieHorseSpawn = fetchurl {
              url = "https://cdn.modrinth.com/data/owDBGfRd/versions/7NVnsQp0/zombiehorsespawn-1.20.4-4.8.jar";
              sha512 = "874acb33045d9d543fe9589298e03bf15f4019c615d62a01be97614d0f5730ee63e8b2f921e1f50bfd89adf6d175da8ce757c4396c13979f8e8c87df9a7384ed";
            };

            AlternateCurrent = fetchurl {
              url = "https://cdn.modrinth.com/data/r0v8vy1s/versions/zrRsTCOk/alternate-current-mc1.20-1.7.0.jar";
              sha512 = "10355abdedd8f23c3ad7afa2268988dbce90306c807ab1076f6103f2263dcaad8323b356d76e585910ed6acd0226dc4031e681462524ed4c4c8c0a3564042619";
            };
          }
        );
      };
    };

    networking.firewall.allowedTCPPorts = [ 25565 ];
  };
}
