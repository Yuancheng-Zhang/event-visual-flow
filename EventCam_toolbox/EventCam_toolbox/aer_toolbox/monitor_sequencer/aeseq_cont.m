function aeseq_cont(usbinterface,addr,ts)
%aeseq_cont(usbinterface,addr,ts)
%
% function to continuously sequence events with one USBAERmini2 device. the device will
% rewind if it reaches the end of the arrays.
%
% this function is non-blocking. call aeseq_cont_stop to stop sequencing
%
% use aeseq if you don't want to sequence continuously
%
% parameters:
%  
%   usbinterface: reference to USBAERmini2 device. get a reference to a
%     USBAERmini2 device using for example usb0=factory.getInterface(0)
%   addr: array of addresses to be sent to device
%   ts: array of interspike intervals. note that no interspike interval
%      should be bigger than 2^16-1. note that you have to set them
%      accoring to the timestamp tick used on the device
% 

if (length(ts)~=length(addr))
    error('addres and timestamps must be of the same size!');
end

if (max(ts)>(2^16-1))
    disp('********** WARNING: the submitted interspike intervals include at least')
    disp('**********          one interspike interval bigger than 2^16-1. This will')
    disp('**********          be interpreted modulo 2^16.')
end

outpacket = ch.unizh.ini.caviar.aemonitor.AEPacketRaw(addr,ts);

if (isempty(usbinterface))
    usbinterface=ch.unizh.ini.caviar.hardwareinterface.usb.CypressFX2MonitorSequencerFactory.instance.getFirstAvailableInterface
end

if ~usbinterface.isOpen()
        usbinterface.open
end

usbinterface.acquireDevice();
usbinterface.resetFifos();
usbinterface.setContinuousSequencingEnabled(true);

usbinterface.sendEventsToDevice(outpacket)