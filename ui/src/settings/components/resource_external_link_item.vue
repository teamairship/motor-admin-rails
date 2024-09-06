<template>
  <div
    class="ivu-card ivu-card-bordered"
    :style="{ opacity: resource.visible ? 1 : 0.5 }"
  >
    <div class="ivu-card-body d-flex align-items-center justify-content-between" @click="onCardClick">
      <div class="d-flex align-items-center">
        <Icon
          type="ios-menu"
          class="me-3 cursor-grab handle"
        />
        <Checkbox
          v-model="resource.visible"
          class="m-0"
          @click.stop
          @change="persistChanges"
        />
        <CustomIcon
          :type="resource.icon || 'database'"
          :size="36"
          class="p-2 mx-1"
          @click.stop="openIconEditor"
        />

        <Contenteditable
          v-model="resource.name"
          class="fs-4 fw-bold"
          @click.stop
          @change="persistChanges"
          withEditButton
          withDeleteButton
          @delete="onDeleteClick"
        />
      </div>

      <div class="d-flex align-items-center">
        <Icon :type="arrowIcon" />
      </div>
    </div>

    <ResourceExternalLinkForm 
      v-if="showEditForm" 
      v-model="resource"
      @cancel="onFormCancel" 
      @submit="persistChanges"
    />


  </div>
</template>

<script>
import api from 'api'
import CustomIcon from 'utils/components/custom_icon'
import ResourceExternalLinkForm from './resource_external_link_form'
import IconSelect from './icon_select'

export default {
  name: 'ResourceExternalLinkItem',
  components: {
    CustomIcon,
    ResourceExternalLinkForm
  },
  data() {
    return {
      showEditForm: false
    }
  },
  props: {
    resource: {
      type: Object,
      required: true
    }
  },

  computed: {
    arrowIcon() {
      return this.showEditForm ? 'ios-arrow-up' : 'ios-arrow-forward'
    }
  },
  methods: {
    openIconEditor () {
      this.$Modal.open(IconSelect, {
        onSelect: (icon) => {
          this.resource.icon = icon

          this.persistChanges()

          this.$Modal.remove()
        },
        onClose: () => {
          this.$Modal.remove()
        }
      })
    },
    persistChanges () {
      return api.put(`external_links/${this.resource.id}`, {
        data: {
          name: this.resource.name,
          url: this.resource.url,
          relative: this.resource.relative,
          preferences: {
            icon: this.resource.icon,
            visible: this.resource.visible
          }
        }
      }).then((result) => {
        this.showEditForm = false
      }).catch((error) => {
        console.error(error)
      })
    },

    onDeleteClick() {
      return api.delete(`external_links/${this.resource.id}`).then((result) => {
        this.$emit('delete', this.resource)
      }).catch((error) => {
        console.error(error)
      })
    },

    onCardClick() {
      this.showEditForm = !this.showEditForm
    },

    onFormCancel() {
      console.log('onFormCancel')
      this.showEditForm = false
    }
  }
}
</script>

<style lang="scss" scoped>
.ivu-card-body {
  padding: 10px 16px;
}
</style>
