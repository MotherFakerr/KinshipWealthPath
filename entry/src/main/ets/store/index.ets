import { Test } from './data_store'

@Component
export struct InjectStore {
  @Provide test: Test = new Test()

  build() {
  }
}