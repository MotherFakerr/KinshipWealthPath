import relationalStore from '@ohos.data.relationalStore'
import { RdbStore } from '../common/database/RdbStore'

export type ICharacterData = {
  id: number,
  value: string;
  wealthTrades: {
    name: string,
    value: number
  }[];
  roleId: string;
  icon?: string;
}

type ICharacterDataWithoutId = Omit<ICharacterData, 'id'>

class RdbCharacterHelperImpl {
  private _store: RdbStore
  private _tableName = 'characters'
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
    name: 'wealthTrades',
    type: 'text',
    nullable: true
  }, {
    name: 'roleId',
    type: 'text',
    nullable: true
  }]
  private _defaultCharacters: ICharacterDataWithoutId[] = [
    {
      value: '张三',
      wealthTrades: [{ name: '红包', value: 800 }],
      roleId: '朋友',
      icon: undefined,
    }
  ]

  public async init(store: RdbStore): Promise<void> {
    this._store = store
    await store.createTable(this._tableName, this._columns)
    await this.addCharacters(this._defaultCharacters)
  }

  public addCharacter(data: ICharacterDataWithoutId, name = this._tableName): Promise<number> {
    return this._store.insert(name, { ...data, wealthTrades: JSON.stringify(data.wealthTrades) })
  }

  public addCharacters(datas: ICharacterDataWithoutId[], name = this._tableName): Promise<number> {
    return this._store.batchInsert(name, datas.map((data) => {
      return { ...data, wealthTrades: JSON.stringify(data.wealthTrades) }
    }))
  }

  public updateCharacter(id: number, data: Partial<ICharacterDataWithoutId>, name = this._tableName): Promise<number> {
    return this._store.update({
      id,
      ...data,
      wealthTrades: data.wealthTrades ? JSON.stringify(data.wealthTrades ?? []) : ''
    }, new relationalStore.RdbPredicates(name))
  }

  public deleteCharacter(id: number, name = this._tableName): Promise<number> {
    const predicates = new relationalStore.RdbPredicates(name)
    predicates.equalTo('id', id)
    return this._store.delete(predicates)
  }

  public async getCharacters(): Promise<ICharacterData[]> {
    const res: ICharacterData[] = []
    const data = await this._store.queryAll(this._tableName)
    const getData = (dataSet: relationalStore.ResultSet) => {
      const count = dataSet.rowCount
      dataSet.goToFirstRow()
      for (let i = 0; i < count; i++) {
        const temp: ICharacterData = {
          id: dataSet.getLong(dataSet.getColumnIndex('id')),
          value: dataSet.getString(dataSet.getColumnIndex('value')),
          wealthTrades: JSON.parse(dataSet.getString(dataSet.getColumnIndex('wealthTrades'))),
          roleId: dataSet.getString(dataSet.getColumnIndex('roleId')),
          icon: dataSet.getString(dataSet.getColumnIndex('icon')),
        }
        res.push(temp)
        dataSet.goToNextRow()
      }
    }
    getData(data)
    return res
  }
}

export const RdbCharacterHelper = new RdbCharacterHelperImpl()
