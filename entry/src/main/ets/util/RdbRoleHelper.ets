import relationalStore from '@ohos.data.relationalStore'
import hilog from '@ohos.hilog'
import { RdbStore } from '../common/database/RdbStore'


export type IRoleData = {
  id: string;
  value: string;
  icon?: string;
  deletable?: boolean
}

export type IRoleDataWithoutId = Omit<IRoleData, 'id'>

enum EN_ROLES {
  未选择 = '未选择',
  亲属 = '亲属',
  朋友 = '朋友',
  同事 = '同事',
}

class RdbRoleHelperImpl {
  private _store: RdbStore
  private _customTableName = 'custom_roles'
  private _columns = [{
    name: 'id',
    type: 'integer',
    primary: true,
    autoincrement: true,
  }, {
    name: 'value',
    type: 'text',
  }, {
    name: 'icon',
    type: 'text',
    nullable: true
  }, {
    name: 'deletable',
    type: 'boolean',
    nullable: true
  }]
  private _defaultRoles: IRoleData[] = [
    {
      id: EN_ROLES.未选择,
      value: EN_ROLES.未选择,
    },
    { id: EN_ROLES.亲属,
      value: EN_ROLES.亲属,
    },
    { id: EN_ROLES.朋友,
      value: EN_ROLES.朋友,
    },
    { id: EN_ROLES.同事,
      value: EN_ROLES.同事,
    }
  ]

  public async init(store: RdbStore): Promise<void> {
    this._store = store
    return store.createTable(this._customTableName, this._columns)
  }

  public addRole(data: IRoleDataWithoutId, name = this._customTableName): Promise<number> {
    return this._store.insert(name, data)
  }

  public addRoles(datas: IRoleDataWithoutId[], name = this._customTableName): Promise<number> {
    return this._store.batchInsert(name, datas)
  }

  public updateRole(id: string, data: Partial<IRoleDataWithoutId>, name = this._customTableName): Promise<number> {
    if (Number.isNaN(Number(id))) {
      return new Promise(resolve => resolve(-1))
    }
    return this._store.update({ id: Number(id), ...data }, new relationalStore.RdbPredicates(name))
  }

  public deleteRole(id: string, name = this._customTableName): Promise<number> {
    if (Number.isNaN(Number(id))) {
      return new Promise(resolve => resolve(-1))
    }
    const predicates = new relationalStore.RdbPredicates(name)
    predicates.equalTo('id', Number(id))
    return this._store.delete(predicates)
  }

  public deleteRoles(ids: string[], name = this._customTableName): Promise<number> {
    if (ids.some(id => Number.isNaN(Number(id)))) {
      return new Promise(resolve => resolve(-1))
    }
    const predicates = new relationalStore.RdbPredicates(name)
    ids.forEach(id => predicates.equalTo('id', Number(id)))
    return this._store.delete(predicates)
  }

  public async getCustomRoles(): Promise<IRoleData[]> {
    const res: IRoleData[] = []
    const data = await this._store.queryAll(this._customTableName)
    const getData = (dataSet: relationalStore.ResultSet) => {
      const count = dataSet.rowCount
      dataSet.goToFirstRow()
      for (let i = 0; i < count; i++) {
        const temp: IRoleData = {
          id: dataSet.getLong(dataSet.getColumnIndex('id')).toString(),
          value: dataSet.getString(dataSet.getColumnIndex('value')),
          icon: dataSet.getString(dataSet.getColumnIndex('icon')),
          deletable: !!dataSet.getLong(dataSet.getColumnIndex('deletable'))
        }
        res.push(temp)
        dataSet.goToNextRow()
      }
    }
    getData(data)
    return res
  }

  public getDefaultRoles(): IRoleData[] {
    return this._defaultRoles
  }
}

export const RdbRoleHelper = new RdbRoleHelperImpl()