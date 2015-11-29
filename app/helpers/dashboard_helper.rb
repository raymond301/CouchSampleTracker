module DashboardHelper

  def modText(noms, hlght)
    pre='<span style="color:red">'
    post='</span>'
    modNames = Array.new
    noms.each do |n|
      idx = n.index(hlght)
      if idx.nil?
        modNames.push(n)
        next
      end
      rix = (idx + hlght.length)
      modNames.push( n.insert(rix, post).insert(idx, pre) )
      #raise [hlght, n.insert(rix, post).insert(idx, pre)].inspect
    end

    return modNames.join(", ").html_safe
  end

end
