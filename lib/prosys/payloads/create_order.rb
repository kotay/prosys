require 'active_support/inflector'
module Prosys
  class CreateOrder < Payload
    def _build opts = {}
      translations = {:rj_adaptors => "RJ_adaptors" }
      doc.order do
        opts.each do |key, value|
          if key == :lines
            doc.lines do
              value.each_with_index do |line,i|
                doc.line("LineNum"=>i) do
                  line.each do |k, v|
                    doc.tag!(k.to_s.camelize, v)
                  end
                end
              end
            end
          else
            node = if translations[key]
              translations[key]
            else
              key.to_s.camelize
            end
            doc.tag!(node, value)
          end
        end
      end
      if @attributes[:testing]
        doc.tag!("test","yes")
      end
    end
  end
end

__END__
<order>
<OrderRef>286</OrderRef>
<Name>Mr Happy</Name>
<CName>Happy House</CName>
<Address>41 Nevison avenue
Chelmsford</Address>
<Postcode>CY22 6EB</Postcode>
<Phone>+44 232 39281</Phone>
<RJ_adaptors>on</RJ_adaptors>
<Saturday>no</Saturday>
<lines>
<line LineNum="0">
<Item>PVSnom360</Item>
<Quantity>1</Quantity>
</line>
</lines>
</order>