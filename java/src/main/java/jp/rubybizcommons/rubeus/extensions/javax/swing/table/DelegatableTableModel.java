package jp.rubybizcommons.rubeus.extensions.javax.swing.table;

import javax.swing.event.TableModelListener;
import javax.swing.table.TableModel;

public class DelegatableTableModel implements TableModel {

	private final TableModel source;
	
	public DelegatableTableModel(TableModel source) {
		super();
		this.source = source;
	}
	
	public TableModel getSource(){
		return this.source;
	}

	public void addTableModelListener(TableModelListener l) {
		source.addTableModelListener(l);
	}

	public Class<?> getColumnClass(int columnIndex) {
		return source.getColumnClass(columnIndex);
	}

	public int getColumnCount() {
		return source.getColumnCount();
	}

	public String getColumnName(int columnIndex) {
		return source.getColumnName(columnIndex);
	}

	public int getRowCount() {
		return source.getRowCount();
	}

	public Object getValueAt(int rowIndex, int columnIndex) {
		return source.getValueAt(rowIndex, columnIndex);
	}

	public boolean isCellEditable(int rowIndex, int columnIndex) {
		return source.isCellEditable(rowIndex, columnIndex);
	}

	public void removeTableModelListener(TableModelListener l) {
		source.removeTableModelListener(l);
	}

	public void setValueAt(Object value, int rowIndex, int columnIndex) {
		source.setValueAt(value, rowIndex, columnIndex);
	}
}
