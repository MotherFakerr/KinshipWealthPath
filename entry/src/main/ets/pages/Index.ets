import { RdbUtil } from '../common/database/RdbUtil';
import { DataStore } from '../store/data_store';
import { ICharacterData } from '../util/RdbCharacterHelper';
import { RdbRoleHelper } from '../util/RdbRoleHelper';
import { RdbStoreHelper } from '../util/RdbStoreHelper';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  @Provide dataStore: DataStore = new DataStore()

  async onPageShow() {
    const dataStore = new DataStore();
    this.dataStore = dataStore
    await dataStore.init()
  }

  build() {
    Row() {
      Column() {
        this.RenderCharacterList()
      }

      .width('100%')
    }
    .height('100%')
  }

  @Builder
  RenderCharacterList() {
    List({ space: 20, initialIndex: 0 }) {
      ForEach(this.getAllCharacters(), (character: ICharacterData) => {
        ListItem() {
          this.RenderCharacterCard(character)
        }.backgroundColor(Color.Black)
      }, (character: ICharacterData) => character.id.toString())
    }
    .listDirection(Axis.Vertical) // 排列方向
    .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 }) // 每行之间的分界线
    .edgeEffect(EdgeEffect.Spring) // 滑动到边缘无效果
    .onScrollIndex((firstIndex: number, lastIndex: number) => {
      console.info('first' + firstIndex)
      console.info('last' + lastIndex)
    })
    .width('90%')

  }

  @Builder
  RenderCharacterCard(character: ICharacterData) {
    Text(character.value)
  }

  getAllCharacters(): ICharacterData[] {
    return [...this.dataStore.characters.values()]
  }
}