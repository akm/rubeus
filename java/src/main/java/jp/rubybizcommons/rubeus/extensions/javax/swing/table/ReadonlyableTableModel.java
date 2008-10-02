package jp.rubybizcommons.rubeus.extensions.javax.swing.table;

import javax.swing.table.TableModel;

public class ReadonlyableTableModel extends DelegatableTableModel {

	public ReadonlyableTableModel(TableModel source) {
		super(source);
	}

	private boolean readonly = false;

	public boolean isReadonly() {
		return readonly;
	}

	public void setReadonly(boolean readonly) {
		this.readonly = readonly;
	}

	public boolean isCellEditable(int rowIndex, int columnIndex) {
		return !isReadonly();
	}
}
