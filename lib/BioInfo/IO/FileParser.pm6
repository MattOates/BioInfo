use BioInfo::Parser;

class BioInfo::IO::FileParser {
    has BioInfo::Parser $!parser;
    has $!channel;
    has $!io_promise;
    has $!fh;

    submethod BUILD(:$file, :$parser) {
        $!parser = $parser;
        $!fh = open($file,:!chomp,:r);
        $!channel = Channel.new();
        $!io_promise = start {
            my $record = '';
            my $in-record = False;
            for $!fh.lines -> $line {
                if $line.index($!parser.rec-start).defined {
                    if $in-record {
                        for $!parser.grammar.parse($record,actions => $!parser.actions).ast -> $obj {
                            $!channel.send($obj);
                        }
                        $record = '';
                    } else {
                        $record = '';
                    }
                }
                $in-record = True;
                $record ~= $line;
            }
            if ($record) {
                $!channel.send($!parser.grammar.parse($record, actions => $!parser.actions).ast[0]);
            }
            $!fh.close;
            $!channel.close;
        };
    }

    method io-is-running {
        return $!io_promise.status == 0;
    }

    method get {
        if $!channel.closed {
            return Nil;
        }
        else {
            return $!channel.receive;
        }
    }
}
