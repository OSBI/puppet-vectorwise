Facter.add(:vectorwise_exists) do
    ENV["PATH"]="/bin:/sbin:/usr/bin:/usr/sbin"
    
    setcode do
        vectorwiseexists = system "ls /home/ingres/.vw > /dev/null 2>&1"
        ($?.exitstatus == 0).to_s
    end
end
