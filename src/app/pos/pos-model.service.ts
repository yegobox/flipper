import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Model, ModelFactory } from 'ngx-model';
import { Pos } from './pos';

@Injectable({
  providedIn: 'root'
})
export class PosModelService {

  pos$: Observable<Pos>;
  private model: Model<Pos>;
  constructor(private modelFactory: ModelFactory<Pos>) {
    this.create();
    this.pos$ = this.model.data$;
   }

   public create(stateCreation:Pos={loading:false}){
    this.model = this.modelFactory.create(stateCreation);

   }

   public get(){
       return this.model.get();
   }

   update(stateUpdates: any) {
    // retrieve raw model data
    const modelSnapshot = this.model.get();
    // mutate model data
    const newModel = { ...modelSnapshot, ...stateUpdates };
    // set new model data (after mutation)
    this.model.set(newModel);
    //console.log('am here booss',this.model.get());
  }


}
