<template>
  <ResourceSettings
    v-if="dataSelectedResource"
    :resource="dataSelectedResource"
    :active-tab="settingsType"
    @back="dataSelectedResource = null"
  />
  <div
    v-else
    class="pt-3"
  >
    <div class="flex justify-end my-3">
      <VButton
        v-if="!addExternalLinkToggled"
        icon="md-add"
        @click="addExternalLink"
      >
        {{ i18n['add_external_link'] }}
      </VButton>

      <ResourceExternalLinkForm 
        v-if="addExternalLinkToggled" 
        @cancel="addExternalLinkToggled = false" 
        @submit="handleExternalLinkSubmit"
      />
    </div>

    <VueDraggableNext
      :list="list"
      ghost-class="ghost"
      handle=".handle"
      @change="updateOrder"
    >

      <div v-for="model in list" :key="model.slug">
        <ResourceExternalLinkItem v-if="model.url"
          :resource="model"
          class="cursor-pointer mb-2"
          @delete="onExternalLinkDeleted" 
        />

        <ResourceItem
          v-else
          :resource="model"
          class="cursor-pointer mb-2"
          @click="dataSelectedResource = model"
        />

      </div>
    </VueDraggableNext>
  </div>
</template>

<script>
import ResourceItem from './resource_list_item'
import ResourceExternalLinkForm from './resource_external_link_form'
import ResourceExternalLinkItem from './resource_external_link_item'
import ResourceSettings from './resource'
import { schema } from 'data_resources/scripts/schema'
import { externalLinks } from 'data_resources/scripts/external_links'
import { resourcesOrder } from 'utils/scripts/configs'
import api from 'api'

export default {
  name: 'ResourcesSettings',
  components: {
    ResourceSettings,
    ResourceItem,
    ResourceExternalLinkForm,
    ResourceExternalLinkItem
  },
  props: {
    selectedResource: {
      type: Object,
      required: false,
      default: null
    },
    settingsType: {
      type: String,
      required: false,
      default: ''
    }
  },
  emits: ['change-resource'],
  data () {
    return {
      dataSelectedResource: this.selectedResource,
      addExternalLinkToggled: false,
      list: this.orderedList(schema.concat(externalLinks))
    }
  },
  computed: {

  },
  watch: {
    dataSelectedResource () {
      this.$emit('change-resource', this.dataSelectedResource)
    }
  },
  methods: {
    addExternalLink() {
      this.addExternalLinkToggled = true
    },
    handleExternalLinkSubmit(externalLink) {
      return api.post('external_links', {
        data: {
          ...externalLink
        }
      }).then((result) => {
        this.list.push(result.data)
        this.addExternalLinkToggled = false
      }).catch((error) => {
        console.error(error)
      })
    },
    updateOrder () {
      return api.post('configs', {
        data: {
          key: 'resources.order',
          value: this.list.map((e) => e.name)
        }
      }).then((result) => {
      }).catch((error) => {
        console.error(error)
      })
    },
    orderedList(input) {
      let orderedResults = resourcesOrder.map((name) => {
        return input.find((e) => e.name === name)
      })

      // remove undefined
      orderedResults = orderedResults.filter((e) => e)

      // add the rest
      input.forEach((e) => {
        if (!orderedResults.includes(e)) {
          orderedResults.push(e)
        }
      })

      return orderedResults
    },
    onExternalLinkDeleted(externalLink) {
      const index = this.list.findIndex((e) => e.id === externalLink.id)
      this.list.splice(index, 1)
    }
  }
}
</script>

<style lang="scss" scoped>
@import 'utils/styles/variables';

:deep(.contenteditable-edit-button) {
  display: none
}

@media screen and (min-width: $breakpoint-md) {
  :deep(.ivu-card:hover) {
    .contenteditable-edit-button {
      display: block
    }

    img {
      border-radius: 5px;
      background: rgba(1,1,1,0.05);
    }
  }
}
</style>
