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
    java_file_list_flavor = java.awt.datatransfer.DataFlavor.javaFileListFlavor
    image_path = e.transferable.get_transfer_data(java_file_list_flavor)[0].absolute_path
    self.icon = javax.swing.ImageIcon.new(image_path)
  end
end
