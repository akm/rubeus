# にゃんこびゅーあーから分離した
# ドラッグ&ドロップ対応の画像表示用ラベル
#
# 2008/6/22 Junya Murabe (Lancard.com)
#

include Java

module DD
  #implements interface
  include java.awt.dnd.DropTargetListener
  def dragEnter(e)
    e.accept_drag java.awt.dnd.DnDConstants::ACTION_COPY
  end

  def dragExit(e); end
  def dragOver(e); end
  def drop(e); end
  def dropActionChanged(e); end

end

class NyancoDispLabel < javax.swing.JLabel
  include DD
  def drop(e)
    e.accept_drop java.awt.dnd.DnDConstants::ACTION_COPY_OR_MOVE

    # Supported Flavors
    java_file_list_flavor = java.awt.datatransfer.DataFlavor.javaFileListFlavor
    string_flavor = java.awt.datatransfer.DataFlavor.stringFlavor
    uri_flavor = java.awt.datatransfer.DataFlavor.new("text/uri-list;class=java.lang.String")

    if e.transferable.isDataFlavorSupported(java_file_list_flavor)
      image_path = e.transferable.get_transfer_data(java_file_list_flavor)[0].absolute_path
    elsif e.transferable.isDataFlavorSupported(string_flavor)
      image_path = java.net.URL.new(e.transferable.get_transfer_data(string_flavor).split("\r\n")[0])
    elsif e.transferable.isDataFlavorSupported(uri_flavor)
      image_path = java.net.URL.new(e.transferable.get_transfer_data(uri_flavor).split("\r\n")[0])
    else
      # Unsupported data
    end 

    if image_path
      self.icon = javax.swing.ImageIcon.new(image_path)
    end
  end
end
