_:
{
  den.aspects.hardware._.amdcpu = {
    _.enable =
      _:
      {
        nixos =
          {
            config,
            lib,
            ...
          }:
          {
            hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

            boot.kernelParams = [ "amd_pstate=active" ];
            powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
          };
      };

    _.performance =
      _:
      {
        nixos.boot.kernelParams = [
          "preempt=full"
          "split_lock_detect=off"
        ];
      };
  };
}
